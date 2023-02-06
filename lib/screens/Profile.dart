import 'dart:io';

import 'package:doantotnghiep/components/pickImage/pick_image_cubit.dart';
import 'package:doantotnghiep/constant.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../components/itemEditProfile.dart';
import '../helper/helper_function.dart';
import '../main.dart';
import '../model/UserInfo.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenwidth,
        height: screenheight,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 160),
                BlocBuilder<PickImageCubit, PickImageState>(
                  builder: (context, state) {
                    if (state is PickImage) {
                      return CircleAvatar(
                        maxRadius: 70,
                        backgroundImage:
                            Image.file(File(state.image.path)).image,
                      );
                    }
                    return CircleAvatar(
                        maxRadius: 70,
                        // backgroundColor: Colors.grey,
                        child: Text(
                          '${Userinfo.userSingleton.name.toString().substring(0, 1)}',
                          style: TextStyle(fontSize: 70),
                        ));
                  },
                ),
                Text(
                  '${Userinfo.userSingleton.name}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Bạn có chắc muốn Đăng xuất?',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            content: Image.asset(
                              'assets/animations/68582-log-out.gif',
                              width: 100,
                              height: 120,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Hủy')),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await HelperFunctions.deleteLoggedUserUid()
                                        .then((value) {
                                      //  context.read<CheckLoggedCubit>().checkUserIsLogged();

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyApp()));
                                    });
                                  },
                                  child: Text('Đồng ý')),
                            ],
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Row(
                      children: [
                        // Container(
                        //     height: 50,
                        //     width: 50,
                        //     decoration: BoxDecoration(
                        //         color: Colors.grey.withOpacity(0.4),
                        //         borderRadius: BorderRadius.circular(10)),
                        //     child:
                        Icon(
                          Icons.logout_sharp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        // ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Đăng xuất',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                top: 250,
                left: 205,
                child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Thay ảnh đại diện',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                itemEditProfile(
                                  title: 'Chụp ảnh',
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 26,
                                  ),
                                  ontap: () {
                                    context
                                        .read<PickImageCubit>()
                                        .pick(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                itemEditProfile(
                                  title: 'Lấy ảnh từ thư viện',
                                  icon: Icon(
                                    Icons.photo_library,
                                    size: 26,
                                  ),
                                  ontap: () {
                                    context
                                        .read<PickImageCubit>()
                                        .pick(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.black54,
                      size: 30,
                    )))
          ],
        ));
  }
}
