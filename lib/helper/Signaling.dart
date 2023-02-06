import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      RTCVideoRenderer remoteRenderer, String grid) async {
    DocumentReference roomRef = db.collection('groups').doc(grid);
    roomRef.get().then(
      (value) async {
        var rs = value.data() as Map<String, dynamic>;
        print(
            'OO Create PeerConnection with configuration: $configuration :${rs['offer']}');
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

          Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

          await roomRef.update(roomWithOffer);

          print('New room created with SDK offer. Room ID: $roomId');

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

  Future<void> joinRoom(String grid, RTCVideoRenderer remoteVideo) async {
    DocumentReference roomRef = db.collection('groups').doc('$grid');
    var roomSnapshot = await roomRef.get();
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
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
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
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
  }

  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    var stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': false});

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  Future<void> hangUp(RTCVideoRenderer localVideo, String grid) async {
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
    var calleeCandidates = await roomRef.collection('calleeCandidates').get();
    calleeCandidates.docs.forEach((document) => document.reference.delete());

    var callerCandidates = await roomRef.collection('callerCandidates').get();
    callerCandidates.docs.forEach((document) => document.reference.delete());
    await roomRef
        .update({'answer': FieldValue.delete(), 'offer': FieldValue.delete()});
    // await roomRef.delete();

    localStream!.dispose();
    remoteStream?.dispose();
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
  }
}