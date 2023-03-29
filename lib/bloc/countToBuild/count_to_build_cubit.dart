import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import 'package:equatable/equatable.dart';



class CountToBuildCubit extends Cubit<int> {
  GroupInfoCubitCubit cubit;
  CountToBuildCubit(this.cubit) : super(0);
  // add(){
  //   emit(state+1);
   
  // }
  init(){
    cubit.stream.listen((event) { 
        print('BEFORE ADD COUNT IS $state');
      if(event is GroupInfoCubitLoaded){
        emit(state+1);
      }
      else if(event is GroupInfoCubitinitial){
        emit(0);
      }
    });
     print('AFTER ADD COUNT IS $state');
  }
}
