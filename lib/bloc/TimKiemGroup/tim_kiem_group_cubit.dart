import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:equatable/equatable.dart';

part 'tim_kiem_group_state.dart';

class TimKiemGroupCubit extends Cubit<TimKiemGroupState> {
  
  TimKiemGroupCubit() : super(TimKiemGroupState(list: [],filterlist: []));
  void TimKiem(List<GroupInfo> list,String value){
   var filter= list.where((element) => element.groupName.toString().toLowerCase().contains(value.toLowerCase())).toList();
   emit(TimKiemGroupState(list: state.list,filterlist: filter));
  }
}
