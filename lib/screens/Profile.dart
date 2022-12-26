import 'package:doantotnghiep/components/pickImage/pick_image_cubit.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../components/itemEditProfile.dart';

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
                CircleAvatar(
                  maxRadius: 70,
                  backgroundColor: Colors.grey,
                  child: Text(
                    '${Userinfo.userSingleton.name.toString().substring(0, 1)}',
                    style: TextStyle(fontSize: 70),
                  ),
                ),
                Text(
                  '${Userinfo.userSingleton.name}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                )
              ],
            ),
            Positioned(
                top: 250,
                left: 225,
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
                                Text('Thay ảnh đại diện', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
                                SizedBox(height: 15,),
                                itemEditProfile(
                                  title: 'Chụp ảnh',
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 26,
                                  ),
                                    ontap: () {
                                    context.read<PickImageCubit>().pick(ImageSource.camera);
                                  },
                                ),
                                SizedBox(height: 15,),
                                itemEditProfile(
                                  title: 'Lấy ảnh từ thư viện',
                                  icon: Icon(
                                    Icons.photo_library,
                                    size: 26,
                                  ),
                                  ontap: () {
                                    context.read<PickImageCubit>().pick(ImageSource.gallery);
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
