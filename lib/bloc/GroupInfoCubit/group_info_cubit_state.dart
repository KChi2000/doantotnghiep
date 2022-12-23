// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'group_info_cubit_cubit.dart';

abstract class GroupInfoCubitState extends Equatable {
  GroupInfoCubitState();

  @override
  List<Object> get props => [];
}

class GroupInfoCubitLoaded extends GroupInfoCubitState {
  List<GroupInfo>? groupinfo;
  GroupInfoCubitLoaded({this.groupinfo});

  @override
  List<Object> get props => [groupinfo!];

  GroupInfoCubitLoaded copyWith({
    List<GroupInfo>? groupinfo,
  }) {
    return GroupInfoCubitLoaded(
      groupinfo: groupinfo ?? this.groupinfo,
    );
  }
}

class GroupInfoCubitLoading extends GroupInfoCubitState {
  GroupInfoCubitLoading();

  @override
  List<Object> get props => [];
}
class GroupInfoCubitinitial extends GroupInfoCubitState {
  GroupInfoCubitinitial();

  @override
  List<Object> get props => [];
}