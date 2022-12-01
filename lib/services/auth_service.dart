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
            .addUserData(fullName, email);  
        await HelperFunctions.saveLoggedUserUid(user.user!.uid);
       Userinfo.userSingleton.uid = user.user!.uid;
        return true;
      }
    } on FirebaseAuthException catch (e) {
       switch (e.code) {
         case "email-already-in-use":
          showSnackbar(context,
              'Error: Email already in use. Please try another email!', Colors.pink);
          break;
           case "invalid-email":
          showSnackbar(context,
              'Enter a valid email!', Colors.pink);
          break;
        case "weak-password":
          showSnackbar(context, 'Error: Password must longer than 6', Colors.pink);
          break;
        case "network-request-failed":
          showSnackbar(context,
              'No network connected!!', Colors.pink);
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
          showSnackbar(context, 'Error: Wrong password!', Colors.pink);
          break;
        case "user-not-found":
          showSnackbar(context,
              'Error: User doesn\'t exists. Try another Account!', Colors.pink);
          break;
        case "invalid-email":
          showSnackbar(context,
              'Enter a valid email!', Colors.pink);
          break;
          case "too-many-requests":
          showSnackbar(context,
              'Too many requests at the same time. Pls try it after 1 minutes!', Colors.pink);
          break;
         
            case "network-request-failed":
          showSnackbar(context,
              'No network connected!!', Colors.pink);
          break;
        default:
          showSnackbar(context, e.toString(), Colors.pink);
      }

      print(e.code);
      return e;
    }
  }

  
}
