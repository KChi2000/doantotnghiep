import 'package:doantotnghiep/components/textfield.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/screens/auth/Login.dart';
import 'package:doantotnghiep/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var emailCon = TextEditingController();

  var passwordCon = TextEditingController();

  var fullnameCon = TextEditingController();

  bool isLoading = false;
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  void register() async {
    setState(() {
      isLoading = true;
    });
    try {
      await authService
          .registerWithEmail(fullnameCon.text, emailCon.text, passwordCon.text)
          .then((value) {
        if (value) {
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    } catch (e) {
       setState(() {
            isLoading = false;
          });
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text('Register'),),
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
              Form(
                key: formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.,
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
                      hint: 'abc',
                      label: 'FullName',
                      icon: Icons.person,
                      iconcolor: Colors.pink,
                      emailCon: fullnameCon,
                      error: 'Chưa nhập họ tên',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    textfield(
                      hint: 'abc@gmail.com',
                      label: 'Email',
                      icon: Icons.email,
                      iconcolor: Colors.pink,
                      emailCon: emailCon,
                      error: 'Chưa nhập email',
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
                      error: 'Chưa nhập mật khẩu',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(minWidth: 100),
                      child: ElevatedButton(
                        onPressed: () {
                          print(emailCon.text);
                          print(passwordCon.text);
                          if (formKey.currentState!.validate()) {
                            register();
                          }
                        },
                        child: isLoading
                            ? SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(),
                              )
                            : Text('Đăng nhập'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Đã có tài khoản?'),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              color: Colors.pink,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
