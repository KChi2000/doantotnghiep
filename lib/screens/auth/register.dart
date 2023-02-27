import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/register/register_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/components/showSnackbar.dart';
import 'package:doantotnghiep/components/textfield.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/main.dart';
import 'package:doantotnghiep/screens/auth/Login.dart';
import 'package:doantotnghiep/NetworkProvider/NetWorkProvider_Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../bloc/FetchLocation/fetch_location_cubit.dart';
import '../../helper/helper_function.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var emailCon = TextEditingController();

  var passwordCon = TextEditingController();

  var fullnameCon = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoaderOverlay(
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
              'Đang đăng ký...',
              style: TextStyle(color: Colors.white),
            )
          ],
        )),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
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
                        SizedBox(
                          width: screenwidth - 100,
                          child: textfieldWithSpace(
                            hint: 'abc',
                            label: 'FullName',
                            icon: Icons.person,
                            iconcolor: Colors.pink,
                            emailCon: fullnameCon,
                            error: 'Chưa nhập họ tên',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: screenwidth - 100,
                          child: textfield(
                            hint: 'abc@gmail.com',
                            label: 'Email',
                            icon: Icons.email,
                            iconcolor: Colors.pink,
                            emailCon: emailCon,
                            error: 'Chưa nhập email',
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
                            error: 'Chưa nhập mật khẩu',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(minWidth: 100),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await context.read<RegisterCubit>().register(
                                    context,
                                    fullnameCon.text,
                                    emailCon.text,
                                    passwordCon.text);
                                await context
                                    .read<FetchLocationCubit>()
                                    .requestLocation();
                              }
                            },
                            child: BlocBuilder<RegisterCubit, RegisterState>(
                              builder: (context, state) {
                                if (state is registerLoading) {
                                  context.loaderOverlay.show();
                                  // return SizedBox(
                                  //   width: 25,
                                  //   height: 25,
                                  //   child: CircularProgressIndicator(),
                                  // );
                                }
                                // if (state is registerLoaded) {
                                //   navigateRempve(context, MyApp());
                                // }
                                context.loaderOverlay.hide();
                                return Text('Đăng kí');
                              },
                            ),
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
        ),
      ),
    );
  }
}
