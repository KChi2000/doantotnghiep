import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'check_logged_state.dart';

class CheckLoggedCubit extends Cubit<CheckLoggedState> {

  CheckLoggedCubit() : super(CheckLoggedState(''));
  void checkUserIsLogged()async{
   try{
     var id=await  HelperFunctions.getLoggedUserUid();
     if(id ==null|| id.isEmpty){
      emit(CheckLoggedState(''));
     }
    else{
      emit(CheckLoggedState(id));
    }
   } catch(e){
    emit(CheckLoggedState(''));
   }
  }
}
