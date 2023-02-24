import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/helper/Signaling.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../NetworkProvider/Networkprovider.dart';

part 'make_a_video_call_state.dart';

class MakeAVideoCallCubit extends Cubit<MakeAVideoCallState> {
  MakeAVideoCallCubit() : super(MakeAVideoCallInitial());
  RTCVideoRenderer localVideo = RTCVideoRenderer();
  RTCVideoRenderer remoteVideo = RTCVideoRenderer();
//   void getusermedia(String groupid) async {
//     localVideo.initialize();
//     remoteVideo.initialize();
//      Signaling.instance.onAddRemoteStream =(stream) {
//     remoteVideo.srcObject=stream;
  
//   };
//  //   await Signaling.instance.openUserMedia(localVideo, remoteVideo);
//   String rs= await Signaling.instance.createRoom(localVideo, groupid);
//     emit(MakeAVideoCallLoaded(
//         localrenderer: localVideo, remoterenderer: remoteVideo,calling: rs));
//   }
// void joinVideoCall(String groupid){
//   Signaling.instance.joinRoom(groupid, remoteVideo);
// }
// void addRemoteStream(){
//   // Signaling.instance.onAddRemoteStream!((stream){
//   //   remoteVideo.srcObject = stream;
//   // });
 
// }
//   void disposevideocall() async {
//     print('dispose');

//     await localVideo.dispose();
//     await remoteVideo.dispose();
//     emit(MakeAVideoCallLoaded(
//         localrenderer: localVideo, remoterenderer: remoteVideo,calling: ''));
//   }
}
