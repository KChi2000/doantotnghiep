import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/model/Signaling.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'make_a_video_call_state.dart';

class MakeAVideoCallCubit extends Cubit<MakeAVideoCallState> {
  MakeAVideoCallCubit() : super(MakeAVideoCallInitial());
  RTCVideoRenderer localVideo = RTCVideoRenderer();
  RTCVideoRenderer remoteVideo = RTCVideoRenderer();
  void getusermedia() async {
    localVideo.initialize();
    remoteVideo.initialize();
    await Singaling.signalinginstance.openUserMedia(localVideo, remoteVideo);
    emit(MakeAVideoCallLoaded(renderer: localVideo));
  }

  void disposevideocall() {
    localVideo.dispose();
    remoteVideo.dispose();
  }
}
