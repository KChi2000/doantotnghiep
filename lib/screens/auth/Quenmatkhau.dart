import 'package:doantotnghiep/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

import '../../components/textfield.dart';

class Quenmatkhau extends StatelessWidget {
  const Quenmatkhau({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quên mật khẩu'),
        ),
        body: Container(
          width: screenwidth,
          height: screenheight,
          child: Column(
            children: [
              Lottie.asset('assets/animations/112418-forgot-password.json'),
              Text(
                'Nhập email vào bên dưới để đặt lại mật khẩu',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: screenwidth - 70,
                  child: TextFormField(
                      decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    isDense: true,
                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                    hintText: '  email',
                    // label: Text(label),
                  ))),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                onPressed: () {}, child: Text('Đặt lại mật khẩu',style: TextStyle(color: Colors.white),))
            ],
          ),
        ));
  }
}
