part of 'make_a_video_call_cubit.dart';

 abstract class MakeAVideoCallState extends Equatable {
  
   MakeAVideoCallState();

  @override
  List<Object> get props => [];
}

class MakeAVideoCallInitial extends MakeAVideoCallState {

}
class MakeAVideoCallLoaded extends MakeAVideoCallState {
  RTCVideoRenderer localrenderer;
    RTCVideoRenderer remoterenderer;
   MakeAVideoCallLoaded({required this.localrenderer,required this.remoterenderer});

  @override
  List<Object> get props => [localrenderer,remoterenderer];
}

