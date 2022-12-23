part of 'get_user_group_cubit.dart';

//  abstract class GetUserGroupState extends Equatable {
 
//    GetUserGroupState();

//   @override
//   List<dynamic> get props => [];
// }

// class GetUserGroupInitial extends GetUserGroupState{}
// class GetUserGroupLoading extends GetUserGroupState{}
class GetUserGroupState{
  Stream? stream;
   GetUserGroupState({this.stream});

  @override
  List<dynamic> get props => [stream];
}