part of 'get_pic_group_member_cubit.dart';

abstract class GetPicGroupMemberState extends Equatable {
  const GetPicGroupMemberState();

  @override
  List<Object> get props => [];
}

class GetPicGroupMemberInitial extends GetPicGroupMemberState {}

class GetPicGroupMemberLoading extends GetPicGroupMemberState {}

class GetPicGroupMemberLoaded extends GetPicGroupMemberState {
  List<Userinfo> list;
  GroupInfo selectedGroup;
  GetPicGroupMemberLoaded(this.list, this.selectedGroup);
  @override
  List<Object> get props => [list, selectedGroup];
}
