import 'dart:io';

import 'package:doantotnghiep/bloc/fetchImage/fetch_image_cubit.dart';
import 'package:doantotnghiep/bloc/getProfile/get_profile_cubit.dart';
import 'package:doantotnghiep/constant.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';

import '../bloc/pickImage/pick_image_cubit.dart';
import '../components/itemEditProfile.dart';
import '../helper/helper_function.dart';
import '../main.dart';
import '../model/User.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    context.read<GetProfileCubit>().getStreamProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
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
            'Đang cập nhật ảnh...',
            style: TextStyle(color: Colors.white),
          )
        ],
      )),
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Profile'),
        //   backgroundColor: Colors.white,
        // ),
        body: BlocConsumer<PickImageCubit, PickImageState>(
          listener: (context, state) {
            Fluttertoast.showToast(
                msg: "Cập nhật ảnh thành công",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                backgroundColor: Colors.pink,
                fontSize: 16.0);
          },
          builder: (context, state) {
            if (state is PickImageLoading) {
              context.loaderOverlay.show();
            } else if (state is PickImageLoaded) {
              context.loaderOverlay.hide();
            }
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
                        BlocBuilder<GetProfileCubit, GetProfileState>(
                          builder: (context, state) {
                            return StreamBuilder<dynamic>(
                                stream: state.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    context
                                        .read<FetchImageCubit>()
                                        .getFromStream(snapshot.data.data());
                                    return BlocBuilder<FetchImageCubit,
                                        FetchImageState>(
                                      builder: (context, state) {
                                        if (state is FetchImageComplete) {
                                          if (state.image.profilePic
                                                      .toString() ==
                                                  null ||
                                              state.image.profilePic
                                                  .toString()
                                                  .isEmpty) {
                                            return CircleAvatar(
                                                // backgroundColor: Colors.teal,
                                                maxRadius: 80,
                                                child: Center(
                                                  child: Text(
                                                    '${Userinfo.userSingleton.name.toString().substring(0, 1)}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 40),
                                                  ),
                                                ));
                                          }
                                          print(
                                              'stream have data ${state.image.profilePic}');
                                          return CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            maxRadius: 80,
                                            backgroundImage: Image.network(
                                              '${state.image.profilePic}',
                                              fit: BoxFit.fill,
                                            ).image,
                                          );
                                        }

                                        return CircleAvatar(
                                            // backgroundColor: Colors.teal,
                                            maxRadius: 80,
                                            child: Image.asset(
                                              'assets/images/loading_image.png',
                                              fit: BoxFit.fill,
                                            ));
                                      },
                                    );
                                  }
                                  print('stream does not have data');
                                  return CircleAvatar(
                                      // backgroundColor: Colors.teal,
                                      maxRadius: 80,
                                      child: Image.asset(
                                        'assets/images/loading_image.png',
                                        fit: BoxFit.fill,
                                      ));
                                });
                          },
                        ),
                        Text(
                          '${Userinfo.userSingleton.name}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                width: screenwidth,
                                child: Text(
                                  'Name       ${Userinfo.userSingleton.name}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                width: screenwidth,
                                child: Text(
                                  'Email       ${(context.read<FetchImageCubit>().state as FetchImageComplete).image.email}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.only(bottom: 10),
                              //   width: screenwidth,
                              //   child: Text(
                              //     'Địa chỉ     Thanh Hóa',
                              //     style: TextStyle(
                              //         fontSize: 16,
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // Container(
                              //   padding: EdgeInsets.only(bottom: 10),
                              //   width: screenwidth,
                              //   child: Text(
                              //     'Sở thích   Đi phượt bằng xe máy',
                              //     style: TextStyle(
                              //         fontSize: 16,
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    title: Text(
                                      'Bạn có chắc muốn Đăng xuất?',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
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
                                            await HelperFunctions
                                                    .deleteLoggedUserUid()
                                                .then((value) {
                                              //  context.read<CheckLoggedCubit>().checkUserIsLogged();

                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyApp()));
                                            });
                                          },
                                          child: Text('Đồng ý')),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
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
                        top: 270,
                        left: 195,
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
                              color: Colors.black,
                              size: 30,
                            )))
                  ],
                ));
          },
        ),
      ),
    );
  }
}

List<String> info = ['Thanh Hóa', 'Thái Nguyên', 'Hà Nội'];
