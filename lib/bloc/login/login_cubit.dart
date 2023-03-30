import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/main.dart';

import 'package:doantotnghiep/NetworkProvider/NetWorkProvider_Auth.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/screens/DisplayPage.dart';
import 'package:equatable/equatable.dart';

import '../../model/User.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  void login(context, String email, String pass) async {
    AuthService authService = AuthService(context: context);
    emit(LoginLoading());
    var result = await authService.LoginWithEmail(email, pass);
    if (result == true) {
      QuerySnapshot snapshot = await DatabaseService().getUserData(email);
      await HelperFunctions.saveLoggedUserUid(snapshot.docs[0]['uid']);
      await HelperFunctions.saveLoggedUserEmail(snapshot.docs[0]['email']);
      await HelperFunctions.saveLoggedUserName(snapshot.docs[0]['fullName']);
      await HelperFunctions.saveUserPic(snapshot.docs[0]['profilePic']);
      Userinfo.userSingleton.saveUserInfo(
          snapshot.docs[0]['uid'],
          snapshot.docs[0]['fullName'],
          snapshot.docs[0]['registration_id'],
          snapshot.docs[0]['profilePic']);
     
      emit(LoginLoaded());
    } else {
      emit(LoginError());
    }
  }
}
