import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/login/login_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/components/textfield.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/main.dart';
import 'package:doantotnghiep/screens/auth/register.dart';
import 'package:doantotnghiep/NetworkProvider/NetWorkProvider_Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
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
                  SizedBox(height: 5,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      
                      children: [
                        SizedBox(width: 220,),
                        Text('Quên mật khẩu?', style: TextStyle(color: Colors.pink,fontSize: 12),),
                        
                      ],
                    )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: 100),
                    child: ElevatedButton(onPressed: () {
                      context
                          .read<LoginCubit>()
                          .login(context, emailCon.text, passwordCon.text);
                    }, child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(),
                          );
                        }
                    
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
    );
  }
}
