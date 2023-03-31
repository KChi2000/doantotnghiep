import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';



class CountToRebuildCubit extends Cubit<int> {
  CountToRebuildCubit() : super(0);
   add(){
    emit(state+1);
   
  }
  init(){
   emit(0);
  }
}
