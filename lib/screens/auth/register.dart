import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/register/register_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/components/showSnackbar.dart';
import 'package:doantotnghiep/components/textfield.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/main.dart';
import 'package:doantotnghiep/screens/auth/Login.dart';
import 'package:doantotnghiep/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

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
                      'C??ng Ph?????t',
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
                      error: 'Ch??a nh???p h??? t??n',
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
                      error: 'Ch??a nh???p email',
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
                      error: 'Ch??a nh???p m???t kh???u',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(minWidth: 100),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            context.read<RegisterCubit>().register(
                                context,
                                fullnameCon.text,
                                emailCon.text,
                                passwordCon.text);
                          }
                        },
                        child: BlocBuilder<RegisterCubit, RegisterState>(
                          builder: (context, state) {
                            if (state is registerLoading) {
                              return SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(),
                              );
                            } 
                            // if (state is registerLoaded) {
                            //   navigateRempve(context, MyApp());
                            // }
                            return Text('????ng k??');
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('???? c?? t??i kho???n?'),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text(
                            '????ng nh???p',
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
