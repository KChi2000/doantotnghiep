import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/helper/helper_function.dart';

import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/User.dart';

part 'check_logged_state.dart';

class CheckLoggedCubit extends Cubit<CheckLoggedState> {

  CheckLoggedCubit() : super(CheckLoggedState(''));
  void checkUserIsLogged()async{
   try{
     var id=await  HelperFunctions.getLoggedUserUid();
     var username = await HelperFunctions.getLoggedUserName();
     var profilePic = await HelperFunctions.getUserPic();
     if(id ==null|| id.isEmpty || username ==null|| username.isEmpty){
      emit(CheckLoggedState(''));
     }
    else{
      Userinfo.userSingleton.saveUserNameId(id, username,profilePic.toString());
      emit(CheckLoggedState(id));
    }
   } catch(e){
    emit(CheckLoggedState(''));
   }
  }
}
