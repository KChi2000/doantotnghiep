import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef void StreamStateCallback(MediaStream stream);

class Signaling {
  static Signaling instance = Signaling();
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
          // 'turn:mogenius-darkl-prod-darklabs-yvu1bw.mo5.mogenius.io:3478'
          // 'turn:udp-mo5.mogenius.io:19683',
          // 'turn:tcp-mo5.mogenius.io:42104'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<String> createRoom(
      RTCVideoRenderer remoteRenderer, String grid, String typeOfcall) async {
    DocumentReference roomRef = db.collection('groups').doc(grid);
    roomRef.get().then(
      (value) async {
     
        var rs = value.data() as Map<String, dynamic>;
        print(
            ' Create PeerConnection with configuration: $configuration :${rs['offer']}');
        if (rs['offer'] == null || rs['offer'].toString().isEmpty) {
          peerConnection = await createPeerConnection(configuration);

          registerPeerConnectionListeners();

          localStream?.getTracks().forEach((track) {
            peerConnection?.addTrack(track, localStream!);
          });

          // Code for collecting ICE candidates below
          var callerCandidatesCollection =
              roomRef.collection('callerCandidates');

          peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
            print('Got candidate: ${candidate.toMap()}');
            callerCandidatesCollection.add(candidate.toMap());
          };
          // Finish Code for collecting ICE candidate

          // Add code for creating a room
          RTCSessionDescription offer = await peerConnection!.createOffer();
          await peerConnection!.setLocalDescription(offer);
          print('Created offer: $offer');

          Map<String, dynamic> roomWithOffer = {
            'offer': offer.toMap(),
            'callStatus': 'calling',
            'recentMessageSender':
                '${Userinfo.userSingleton.name}_${Userinfo.userSingleton.uid}',
            'recentMessage': ' đã bắt đầu cuôc gọi $typeOfcall',
            'time': '${DateTime.now().microsecondsSinceEpoch.toString()}',
            'type': typeOfcall == 'video' ? 'callvideo' : 'callaudio'
          };

          await roomRef.update(roomWithOffer);
          await roomRef.collection('Messages').add({
            'contentMessage': ' đã bắt đầu cuộc gọi $typeOfcall',
            'sender':
                '${Userinfo.userSingleton.name}_${Userinfo.userSingleton.uid}',
            'time': '${DateTime.now().microsecondsSinceEpoch}',
            'type': typeOfcall == 'video' ? 'callvideo' : 'callaudio'
          });
         

          peerConnection?.onTrack = (RTCTrackEvent event) {
            print('[MyRTC] Got remote track: ${event.streams[0]}');

            event.streams[0].getTracks().forEach((track) {
              print('[MyRTC] Add a track to the remoteStream $track');
              remoteStream?.addTrack(track);
            });
          };

          // Listening for remote session description below
          roomRef.snapshots().listen((snapshot) async {
            print('Got updated room: ${snapshot.data()}');

            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            if (peerConnection?.getRemoteDescription() != null &&
                data['answer'] != null) {
              var answer = RTCSessionDescription(
                data['answer']['sdp'],
                data['answer']['type'],
              );

              print("Someone tried to connect");
              await peerConnection?.setRemoteDescription(answer);
            }
          });
          // Listening for remote session description above

          // Listen for remote Ice candidates below
          roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
            snapshot.docChanges.forEach((change) {
              if (change.type == DocumentChangeType.added) {
                Map<String, dynamic> data =
                    change.doc.data() as Map<String, dynamic>;
                print('Got new remote ICE candidate: ${jsonEncode(data)}');
                peerConnection!.addCandidate(
                  RTCIceCandidate(
                    data['candidate'],
                    data['sdpMid'],
                    data['sdpMLineIndex'],
                  ),
                );
              }
            });
          });
          return 'no one is caling';
        }
      },
    );

    // Listen for remote ICE candidates above

    return 'someone is calling';
  }

  Future<void> joinRoom(
      String grid, RTCVideoRenderer remoteVideo, String typeOfcall) async {
    DocumentReference roomRef = db.collection('groups').doc(grid);
    roomRef.get().then((roomSnapshot) async {
      if (roomSnapshot.exists) {
        peerConnection = await createPeerConnection(configuration);
        registerPeerConnectionListeners();
        localStream?.getTracks().forEach((track) {
          peerConnection?.addTrack(track, localStream!);
        });
        await roomRef.collection('Messages').add({
          'contentMessage': 'đã tham gia cuộc gọi $typeOfcall',
          'sender':
              '${Userinfo.userSingleton.name}_${Userinfo.userSingleton.uid}',
          'time': '${DateTime.now().microsecondsSinceEpoch}',
          'type': 'announce'
        });
        await roomRef.update({
          'recentMessage':
              '${Userinfo.userSingleton.name} đã tham gia cuộc gọi $typeOfcall',
          'recentMessageSender': '',
          'type': 'announce'
        });
        // Code for collecting ICE candidates below
        var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
        peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
          if (candidate == null) {
            print('onIceCandidate: complete!');
            return;
          }
          print('onIceCandidate: ${candidate.toMap()}');
          calleeCandidatesCollection.add(candidate.toMap());
        };
        // Code for collecting ICE candidate above

        peerConnection?.onTrack = (RTCTrackEvent event) {
          print('[MyRTC] Got remote track: ${event.streams[0]}');
          event.streams[0].getTracks().forEach((track) {
            print(
                '[MyRTC] Add a track to the remoteStream: $track $remoteStream ${remoteStream.hashCode}');
            remoteStream?.addTrack(track);
          });
        };

        // Code for creating SDP answer below
        var data = roomSnapshot.data() as Map<String, dynamic>;
        print('Got offer $data');
        var offer = data['offer'];
        await peerConnection?.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']),
        );
        var answer = await peerConnection!.createAnswer();
        print('Created Answer $answer');

        await peerConnection!.setLocalDescription(answer);

        Map<String, dynamic> roomWithAnswer = {
          'answer': {'type': answer.type, 'sdp': answer.sdp},
          'callStatus': 'happening'
        };

        await roomRef.update(roomWithAnswer);
        // Finished creating SDP answer

        // Listening for remote ICE candidates below
        roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
          snapshot.docChanges.forEach((document) {
            var data = document.doc.data() as Map<String, dynamic>;

            print('Got new remote ICE candidate: $data');
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          });
        });
      }
    });
  }

  Future<void> openUserMedia(
      RTCVideoRenderer localVideo,
      RTCVideoRenderer remoteVideo,
      bool isVideoOn,
      bool isAudioOn,
      isFrontCameraSelected) async {
    var stream = await navigator.mediaDevices.getUserMedia({
      'video': isVideoOn
          ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
          : false,
      'audio': isAudioOn
    });

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  switchCamera(bool isFrontCameraSelected) {
    // change status
    // isFrontCameraSelected = !isFrontCameraSelected;

    // switch camera
    localStream?.getVideoTracks().forEach((track) {
      // ignore: deprecated_member_use
      track.switchCamera();
    });
  }

  toggleMic(bool isAudioOn) {
    // change status
    // isAudioOn = !isAudioOn;
    // enable or disable audio track
    localStream?.getAudioTracks().forEach((track) {
      track.enabled = !isAudioOn;
    });
  }

  toggleCamera(bool isVideoOn) {
    // // change status
    // isVideoOn = !isVideoOn;

    // enable or disable video track
    localStream?.getVideoTracks().forEach((track) {
      track.enabled = !isVideoOn;
    });
  }

  Future<void> hangUp(
      RTCVideoRenderer localVideo, String grid, String typeOfcall) async {
    final batch = db.batch();
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    // var db = FirebaseFirestore.instance;
    var roomRef = db.collection('groups').doc(grid);
    await roomRef.collection('Messages').add({
      'contentMessage': 'Cuộc gọi $typeOfcall đã kết thúc',
      'sender': '${Userinfo.userSingleton.name}_${Userinfo.userSingleton.uid}',
      'time': '${DateTime.now().microsecondsSinceEpoch}',
      'type': typeOfcall == 'video' ? 'callvideo' : 'callaudio'
    });
    await roomRef.collection('calleeCandidates');
    var calleeCandidates = await roomRef.collection('calleeCandidates').get();
    calleeCandidates.docs
        .forEach((document) => batch.delete(document.reference));

    var callerCandidates = await roomRef.collection('callerCandidates').get();
    callerCandidates.docs
        .forEach((document) => batch.delete(document.reference));
    await batch.commit();
    await roomRef.update({
      'answer': FieldValue.delete(),
      'offer': FieldValue.delete(),
      'callStatus': 'call end',
      'recentMessage': 'Kết thúc cuộc gọi video'
    });
    // await roomRef.delete();

    localStream!.dispose();
    remoteStream?.dispose();
  }
void removeRemoteStream(){

}
  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("[MyRTC] Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
    peerConnection?.onRemoveStream=(stream) {
      print('[MyRTC] SOMEONE HAVE LEFT OUT');
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}
