// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tim_kiem_group_cubit.dart';

class TimKiemGroupState extends Equatable {
  List<GroupInfo> list;
  List<GroupInfo> filterlist;
   TimKiemGroupState({required this.list,required this.filterlist});

  @override
  List<Object> get props => [list,filterlist];

  TimKiemGroupState copyWith({
    List<GroupInfo>? list,
    List<GroupInfo>? filterlist,
  }) {
    return TimKiemGroupState(
      list: list ?? this.list,
      filterlist: filterlist ?? this.filterlist,
    );
  }
}


