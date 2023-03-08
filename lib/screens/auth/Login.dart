import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/login/login_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/components/textfield.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/main.dart';
import 'package:doantotnghiep/screens/auth/Quenmatkhau.dart';
import 'package:doantotnghiep/screens/auth/register.dart';
import 'package:doantotnghiep/NetworkProvider/NetWorkProvider_Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../NetworkProvider/Networkprovider.dart';

final RegExp _emailRegExp = RegExp(
  r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
);

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailCon = TextEditingController();

  var passwordCon = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // appBar: AppBar(title: Text('Login'),),
        body: LoaderOverlay(
             useDefaultLoading: false,
        overlayOpacity: 0.6,
        overlayWidget: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text(
              'Đang đăng nhập...',
              style: TextStyle(color: Colors.white),
            )
          ],
        )),
          child: SingleChildScrollView(
            child: Container(
              // color: Colors.amber,
              width: screenwidth,
              height: screenheight,
              child: Stack(
                children: [
                  // Opacity(
                  //   opacity: 0.8,
                  //   child: Image.asset(
                  //     'assets/images/Couple travelling by bike flat vector illustration.jpg',
                  //     fit: BoxFit.fitHeight,
                  //   ),
                  // ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
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
                      Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: screenwidth - 100,
                                child: textfield(
                                  hint: 'abc@gmail.com',
                                  label: 'Email',
                                  icon: Icons.email,
                                  iconcolor: Colors.pink,
                                  emailCon: emailCon,
                                  error: 'Chưa điền email',
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: screenwidth - 100,
                                child: textfield(
                                  hint: '123456',
                                  label: 'Password',
                                  icon: Icons.lock,
                                  iconcolor: Colors.pink,
                                  emailCon: passwordCon,
                                  error: 'Chưa điền mật khẩu',
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 220,
                              ),
                              GestureDetector(
                                onTap: () {
                                  navigatePush(context, Quenmatkhau());
                                },
                                child: Text(
                                  'Quên mật khẩu?',
                                  style: TextStyle(
                                      color: Colors.pink, fontSize: 12),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 100),
                        child: ElevatedButton(onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<LoginCubit>().login(
                                context, emailCon.text, passwordCon.text);
                          }
                        }, child: BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            if (state is LoginLoading) {
                              context.loaderOverlay.show();
                            }
                            context.loaderOverlay.hide();
                            return Text('Đăng nhập');
                          },
                        )),
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
        ),
      ),
    );
  }
}
