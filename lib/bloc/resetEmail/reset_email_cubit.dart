import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/NetworkProvider/NetWorkProvider_Auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'reset_email_state.dart';

class ResetEmailCubit extends Cubit<ResetEmailState> {
  ResetEmailCubit() : super(ResetEmailInitial());
  void sendRequestReset(String email) async {
    try {
      emit(ResetEmailLoading());
      String s = await AuthService.instance.ResetPassword(email);
      if (s == 'success') {
        emit(ResetEmailLoaded());
      } else {
        emit(ResetEmailError(s));
      }
    } on FirebaseAuthException catch (e) {
      emit(ResetEmailError(e.toString()));
    }
  }
}
