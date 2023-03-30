import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import 'package:equatable/equatable.dart';



class CountToBuildCubit extends Cubit<int> {
  GroupInfoCubitCubit cubit;
  CountToBuildCubit(this.cubit) : super(0);
  add(){
    emit(state+1);
   
  }
  init(){
   emit(0);
  }
}
