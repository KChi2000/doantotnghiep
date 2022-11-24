import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/components/textfield.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/main.dart';
import 'package:doantotnghiep/screens/auth/register.dart';
import 'package:doantotnghiep/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../services/database_service.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailCon = TextEditingController();

  var passwordCon = TextEditingController();
  bool loading = false;
  late AuthService authService;
  bool success = false;
  void LogIn() async {
    setState(() {
      loading = true;
    });
    authService.LoginWithEmail(emailCon.text, passwordCon.text)
        .then((value) async {
      if (value == true) {
        QuerySnapshot snapshot =
            await DatabaseService().getUserData(emailCon.text.trim());
        await HelperFunctions.saveLoggedUserUid(snapshot.docs[0]['uid']);
        await HelperFunctions.saveLoggedUserEmail(snapshot.docs[0]['email']);
        await HelperFunctions.saveLoggedUserName(snapshot.docs[0]['fullName']);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      }
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    authService = AuthService(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text('Login'),),
        body: Container(
          // color: Colors.amber,
          width: screenwidth,
          height: screenheight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Opacity(
              //   opacity: 0.8,
              //   child: Image.asset(
              //     'assets/images/Couple travelling by bike flat vector illustration.jpg',
              //     fit: BoxFit.fitHeight,
              //   ),
              // ),
              Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  GradientText(
                    'Cùng Phượt',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'beautiFont',
                        fontSize: 45),
                    colors: [
                      // Colors.green,
                      Colors.yellow,
                      Colors.orange,
                      Colors.purple,
                      Colors.pink,
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  textfield(
                    hint: 'abc@gmail.com',
                    label: 'Email',
                    icon: Icons.email,
                    iconcolor: Colors.pink,
                    emailCon: emailCon,
                    error: 'Chưa điền email',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  textfield(
                    hint: '123456',
                    label: 'Password',
                    icon: Icons.lock,
                    iconcolor: Colors.pink,
                    emailCon: passwordCon,
                    error: 'Chưa điền mật khẩu',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: 100),
                    child: ElevatedButton(
                        onPressed: () {
                          LogIn();
                        },
                        child: loading
                            ? SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(),
                              )
                            : Text('Đăng nhập')),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Chưa có tài khoản?'),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: Text(
                          'Đăng kí',
                          style: TextStyle(
                            color: Colors.pink,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
