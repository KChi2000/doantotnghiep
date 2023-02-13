import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:equatable/equatable.dart';

part 'tim_kiem_group_state.dart';

class TimKiemGroupCubit extends Cubit<TimKiemGroupState> {
  TimKiemGroupCubit() : super(TimKiemGroupState(list: [], filterlist: [],text: ''));
  void TimKiem(List<GroupInfo> list, String value) {
    List<GroupInfo> filter = [];
    if (value.isNotEmpty && value != null) {
      filter = list
          .where((element) => element.groupName
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    }
    emit(TimKiemGroupState(list: state.list, filterlist: filter,text: value));
  }

  void resetfilterlist() {
    emit(TimKiemGroupState(list: state.list, filterlist: [],text: state.text));
  }
void afterchange(List<GroupInfo> list) {
     List<GroupInfo> filter = [];
   
      filter = list
          .where((element) => element.groupName
              .toString()
              .toLowerCase()
              .contains(state.text.toLowerCase()))
          .toList() ?? [];

    print('in filter list : ${filter.length} ${filter.first.groupName}');
    emit(TimKiemGroupState(list: list, filterlist: filter,text: ''));
  }

}
