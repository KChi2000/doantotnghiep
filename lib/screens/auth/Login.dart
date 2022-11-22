import 'package:doantotnghiep/components/textfield.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Login extends StatelessWidget {
  Login({super.key});
  var emailCon = TextEditingController();
  var passwordCon = TextEditingController();
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
                      hint: 'abc@gmail.com',
                      label: 'Email',
                      icon: Icons.email,
                      iconcolor: Colors.pink,
                      emailCon: emailCon,
                       error: 'Chưa điền email',),
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
                  ElevatedButton(onPressed: () {}, child: Text('Đăng nhập')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Chưa có tài khoản?'),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Register()));
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

