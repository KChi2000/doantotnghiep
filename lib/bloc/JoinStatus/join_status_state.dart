part of 'join_status_cubit.dart';
abstract class JoinState extends Equatable{
  JoinState();
   @override
  List<Object> get props => [];
}
 class JoindStatusState extends JoinState {
  bool joined;
   JoindStatusState({required this.joined});

  @override
  List<Object> get props => [joined];
}
class Processing extends JoinState{
  Processing();
   @override
  List<Object> get props => [];
}

