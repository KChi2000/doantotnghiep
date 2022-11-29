part of '../joinToGroup.dart/join_to_group_cubit.dart';

abstract class JoinToGroupState extends Equatable {

   JoinToGroupState();

}
class InitialGroup extends JoinToGroupState{
   InitialGroup();
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class LoadingGroup extends JoinToGroupState{
   LoadingGroup();
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class LoadedGroup extends JoinToGroupState{
    GroupInfo data;
   LoadedGroup(this.data);
  
 
  @override
  List<Object> get props => [data];
}
class ErrorState extends JoinToGroupState{
   ErrorState();
  
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
