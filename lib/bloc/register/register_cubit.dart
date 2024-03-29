import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/main.dart';

import 'package:doantotnghiep/NetworkProvider/NetWorkProvider_Auth.dart';
import 'package:equatable/equatable.dart';

import '../../model/User.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  register(context, String name, String email, String pass,String sothich) async {
    AuthService authService = AuthService(context: context);
    emit(registerLoading());
    var result = await authService.registerWithEmail(name, email, pass,sothich);

    if (result == true) {
      await HelperFunctions.saveLoggedUserEmail(email);
      await HelperFunctions.saveLoggedUserName(name);
      emit(registerLoaded());
      Userinfo.userSingleton.name = name;
      navigateReplacement(context, MyApp());
    } else {
     
      emit(registerError());
    }
  }
}
