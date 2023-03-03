import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/pickImage/pick_image_cubit.dart';
import 'itemEditProfile.dart';

class editProfile extends StatelessWidget {
  editProfile({
    required this.circleAvatar,
  });
  Widget circleAvatar;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        circleAvatar,
        Positioned(
            bottom: 0,
            right: 20,
            child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Thay ảnh đại diện',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
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
                  color: Colors.black,
                  size: 30,
                )))
      ],
    );
  }
}