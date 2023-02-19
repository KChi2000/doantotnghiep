import 'package:doantotnghiep/bloc/resetEmail/reset_email_cubit.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';

import '../../components/textfield.dart';

class Quenmatkhau extends StatefulWidget {
  Quenmatkhau({super.key});

  @override
  State<Quenmatkhau> createState() => _QuenmatkhauState();
}

class _QuenmatkhauState extends State<Quenmatkhau> {
  var emailCon = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Quên mật khẩu'),
        ),
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
                'Đang gửi yêu cầu...',
                style: TextStyle(color: Colors.white),
              )
            ],
          )),
          child: SingleChildScrollView(
            child: Container(
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
                  Form(
                    key: formKey,
                    child: SizedBox(
                        width: screenwidth - 70,
                        child: textfield(
                            hint: 'Nhập email',
                            label: 'Email',
                            icon: Icons.email,
                            iconcolor: Colors.pink,
                            emailCon: emailCon,
                            error: 'Chưa nhập email')),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  BlocConsumer<ResetEmailCubit, ResetEmailState>(
                    listener: (context, state) {
                      if (state is ResetEmailLoading) {
                        context.loaderOverlay.show();
                      } else if (state is ResetEmailLoaded) {
                        context.loaderOverlay.hide();
                        'Link đặt lại mật khẩu đã được gửi đến email của bạn';
                        Fluttertoast.showToast(
                            msg:
                                "Link đặt lại mật khẩu đã được gửi đến email của bạn",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            backgroundColor: Colors.pink,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      } else if (state is ResetEmailError) {
                        context.loaderOverlay.hide();
                        Fluttertoast.showToast(
                            msg: "${state.error}",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            backgroundColor: Colors.pink,
                            fontSize: 16.0);
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context
                                  .read<ResetEmailCubit>()
                                  .sendRequestReset(emailCon.text);
                            }
                          },
                          child: Text(
                            'Đặt lại mật khẩu',
                            style: TextStyle(color: Colors.white),
                          ));
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
