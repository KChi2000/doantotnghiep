import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/showSnackbar.dart';

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
        await DatabaseService(uid: user.user!.uid)
            .addUserData(fullName, email)
            .then((value) => true);
        await HelperFunctions.saveLoggedUserUid(user.user!.uid);
        setUserinfo(user.user!.uid, fullName, email);
        print(userinfo.name);
      }
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.toString(), Colors.pink);
      return e;
    }
  }

  Future LoginWithEmail(String email, String pass) async {
    try {
      var user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pass);
         
          return true;
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.toString(), Colors.pink);
      return e;
    }
  }

  void setUserinfo(String id, String name, String email) {
    userinfo.uid = id;
    userinfo.name = name;
    userinfo.email = email;
  }
}
