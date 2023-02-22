import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/helper/helper_function.dart';

import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/showSnackbar.dart';
import '../model/User.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static AuthService _instance = AuthService();
  static AuthService get instance => _instance;

  BuildContext? context;
  AuthService({this.context});
  Userinfo userinfo = Userinfo();

  Future registerWithEmail(String fullName, String email, String pass) async {
    try {
      var user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: pass);

      if (user != null) {
        await DatabaseService(uid: user.user!.uid).addUserData(fullName, email);
        await HelperFunctions.saveLoggedUserUid(user.user!.uid);
        Userinfo.userSingleton.uid = user.user!.uid;
        return true;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          showSnackbar(
              context,
              'Error: Email này đã được sử dụng. Xin hãy sử dụng email khác!',
              Colors.pink);
          break;
        case "invalid-email":
          showSnackbar(context, 'Email không hợp lệ!', Colors.pink);
          break;
        case "weak-password":
          showSnackbar(
              context, 'Error: Mật khẩu nên có tối thiểu 6 ký tự', Colors.pink);
          break;
        case "network-request-failed":
          showSnackbar(context, 'Không có kết nối Internet!!', Colors.pink);
          break;

        default:
          showSnackbar(context, e.toString(), Colors.pink);
      }
      print(' sevice: ${e.code}');
      return e;
    }
  }

  Future LoginWithEmail(String email, String pass) async {
    try {
      var user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pass);

      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          showSnackbar(
              context, 'Error: Sai tài khoản hoặc mật khẩu!', Colors.pink);
          break;
        case "user-not-found":
          showSnackbar(
              context,
              'Error: Tài khoản không tồn tại. Xin hãy thử 1 tài khoản khác!',
              Colors.pink);
          break;
        case "invalid-email":
          showSnackbar(context, 'Email không hợp lệ!', Colors.pink);
          break;
        case "too-many-requests":
          showSnackbar(
              context,
              'Quá nhiều yêu cầu trong một lần. Hãy thử lại sau 1 phút!',
              Colors.pink);
          break;

        case "network-request-failed":
          showSnackbar(context, 'Không có kết nối Internet!!', Colors.pink);
          break;
        default:
          showSnackbar(context, e.toString(), Colors.pink);
      }

      print(e.code);
      return e;
    }
  }

  Future<String> ResetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }
}
