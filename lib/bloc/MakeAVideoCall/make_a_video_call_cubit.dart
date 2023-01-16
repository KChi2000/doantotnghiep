import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/model/Signaling.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../services/database_service.dart';

part 'make_a_video_call_state.dart';

class MakeAVideoCallCubit extends Cubit<MakeAVideoCallState> {
  MakeAVideoCallCubit() : super(MakeAVideoCallInitial());
  RTCVideoRenderer localVideo = RTCVideoRenderer();
  RTCVideoRenderer remoteVideo = RTCVideoRenderer();
  void getusermedia(String groupid) async {
    localVideo.initialize();
    remoteVideo.initialize();
    await DatabaseService.instance.openUserMedia(localVideo, remoteVideo);
   await DatabaseService.instance.createRoom(localVideo, groupid);
    emit(MakeAVideoCallLoaded(
        localrenderer: localVideo, remoterenderer: remoteVideo));
  }
void joinVideoCall(String groupid){
  DatabaseService.instance.joinRoom(groupid, remoteVideo);
}
void addRemoteStream(){
  // DatabaseService.instance.onAddRemoteStream!((stream){
  //   remoteVideo.srcObject = stream;
  // });
  DatabaseService.instance.onAddRemoteStream =(stream) {
    remoteVideo.srcObject=stream;
    emit(MakeAVideoCallLoaded(
        localrenderer: localVideo, remoterenderer: remoteVideo));
  };
}
  void disposevideocall() async {
    print('dispose');

    await localVideo.dispose();
    await remoteVideo.dispose();
    emit(MakeAVideoCallLoaded(
        localrenderer: localVideo, remoterenderer: remoteVideo));
  }
}
