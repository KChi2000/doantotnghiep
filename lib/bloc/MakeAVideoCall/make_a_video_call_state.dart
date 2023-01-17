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
  String calling;
   MakeAVideoCallLoaded({required this.localrenderer,required this.remoterenderer,required this.calling});

  @override
  List<Object> get props => [localrenderer,remoterenderer,calling];
}

