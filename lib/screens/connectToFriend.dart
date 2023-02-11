import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/getInviteId/get_invite_id_cubit.dart';
import 'package:doantotnghiep/bloc/getUserGroup/get_user_group_cubit.dart';
import 'package:doantotnghiep/bloc/showBoxInviteId/show_box_invite_id_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:doantotnghiep/model/Message.dart';

import 'package:doantotnghiep/screens/JoinGroup.dart';
import 'package:doantotnghiep/screens/SearchGroup.dart';
import 'package:doantotnghiep/screens/auth/Quenmatkhau.dart';
import 'package:doantotnghiep/screens/chatDetail.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rive/rive.dart';

import '../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../model/UserInfo.dart';

class ConnectToFriend extends StatefulWidget {
  ConnectToFriend({super.key});

  @override
  State<ConnectToFriend> createState() => _ConnectToFriendState();
}

class _ConnectToFriendState extends State<ConnectToFriend> {
  var groupNameCon = TextEditingController();
  var formkey = GlobalKey<FormState>();
  late Artboard artboard;
  late RiveAnimationController riveAnimationController;

  @override
  void initState() {
    context.read<GetUserGroupCubit>().getUerGroup();
    super.initState();
    riveAnimationController = SimpleAnimation('loading');

   
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.6,
      overlayWidget: Center(child: CircularProgressIndicator()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          elevation: 3,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: .0),
              child: IconButton(
                icon: Icon(Icons.group_add_rounded),
                onPressed: () {
                  String invitedId = getRandomString(6);
                  groupNameCon.clear();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            height: 290,
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 90,
                                    ),
                                    Container(
                                      height: 200,
                                      // width: 200,
                                      child: RiveAnimation.asset(
                                        'assets/animations/nice.riv',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 30, right: 30, left: 30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Tạo nhóm',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Form(
                                        key: formkey,
                                        child: TextFormField(
                                          controller: groupNameCon,
                                          decoration: InputDecoration(
                                              hintText: 'group\'s name',
                                              isDense: true,
                                              border: OutlineInputBorder()),
                                          validator: (value) {
                                            if (groupNameCon.text.isEmpty ||
                                                groupNameCon.text.length == 0) {
                                              return 'Tên nhóm không được để trống';
                                            }
                                            return null;
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Copy mã bên dưới để mời bạn bè tham gia vào nhóm',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 300,
                                        padding: EdgeInsets.only(left: 10),
                                        color: Colors.grey.withOpacity(0.3),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              invitedId,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Clipboard.setData(
                                                          ClipboardData(
                                                              text: invitedId))
                                                      .then((_) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Invite id copied to clipboard: $invitedId"),
                                                      duration:
                                                          Duration(seconds: 2),
                                                    ));
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.copy,
                                                  color: Colors.black54,
                                                ))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Hủy')),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          TextButton(
                                              onPressed: () async {
                                                if (formkey.currentState!
                                                    .validate()) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text('Tạo nhóm'))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        // return AlertDialog(
                        //   actionsPadding: EdgeInsets.zero,
                        //   title: Text('Create group'),
                        //   content: Container(
                        //     height: 210,
                        // child: Stack(
                        //   children: [
                        //     RiveAnimation.asset(
                        //       'assets/animations/nice.riv',
                        //       fit: BoxFit.fitHeight,
                        //     ),
                        //     Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Form(
                        //           key: formkey,
                        //           child: TextFormField(
                        //             controller: groupNameCon,
                        //             decoration: InputDecoration(
                        //                 hintText: 'group\'s name',
                        //                 isDense: true,
                        //                 border: OutlineInputBorder()),
                        //             validator: (value) {
                        //               if (groupNameCon.text.isEmpty ||
                        //                   groupNameCon.text.length == 0) {
                        //                 return 'Tên nhóm không được để trống';
                        //               }
                        //               return null;
                        //             },
                        //             autovalidateMode:
                        //                 AutovalidateMode.onUserInteraction,
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 5,
                        //         ),
                        //         Text(
                        //             'Copy mã bên dưới để mời bạn bè tham gia vào nhóm'),
                        //         Container(
                        //           height: 40,
                        //           width: 300,
                        //           padding: EdgeInsets.only(left: 10),
                        //           color: Colors.grey.withOpacity(0.3),
                        //           child: Row(
                        //             mainAxisSize: MainAxisSize.min,
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Text(
                        //                 invitedId,
                        //                 style: TextStyle(
                        //                     fontSize: 16,
                        //                     color: Colors.black87),
                        //               ),
                        //               IconButton(
                        //                   onPressed: () {
                        //                     Clipboard.setData(ClipboardData(
                        //                             text: invitedId))
                        //                         .then((_) {
                        //                       ScaffoldMessenger.of(context)
                        //                           .showSnackBar(SnackBar(
                        //                         content: Text(
                        //                             "Invite id copied to clipboard: $invitedId"),
                        //                         duration:
                        //                             Duration(seconds: 2),
                        //                       ));
                        //                     });
                        //                   },
                        //                   icon: Icon(
                        //                     Icons.copy,
                        //                     color: Colors.black54,
                        //                   ))
                        //             ],
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 8,
                        //         ),
                        //         Row(
                        //           mainAxisSize: MainAxisSize.max,
                        //           mainAxisAlignment: MainAxisAlignment.end,
                        //           children: [
                        //             TextButton(
                        //                 onPressed: () {
                        //                   Navigator.pop(context);
                        //                 },
                        //                 child: Text('Cancel')),
                        //             SizedBox(
                        //               width: 8,
                        //             ),
                        //             TextButton(
                        //                 onPressed: () async {
                        //                   Navigator.pop(context);
                        //                 },
                        //                 child: Text('Create'))
                        //           ],
                        //         )
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        //   ),
                        // );
                      }).whenComplete(() async {
                    if (formkey.currentState!.validate()) {
                      context.loaderOverlay.show();

                      await DatabaseService(
                        uid: Userinfo.userSingleton.uid,
                      ).CreateGroup(
                          groupNameCon.text,
                          Userinfo.userSingleton.uid!,
                          Userinfo.userSingleton.name!,
                          invitedId);
                      print('create group thanh cong');
                      context.loaderOverlay.hide();
                      Fluttertoast.showToast(
                          msg: "Tạo nhóm thành công",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          backgroundColor: Colors.pink,
                          fontSize: 16.0);
                    }
                  });
                },
              ),
            ),
          ],
        ),
        body: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            context.read<GroupInfoCubitCubit>().setFalse();
          },
          child: Stack(
            children: [
              Container(
                width: screenwidth,
                height: screenheight,
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child:
                            BlocBuilder<GetUserGroupCubit, GetUserGroupState>(
                          builder: (context, state) {
                            return StreamBuilder<dynamic>(
                                stream: state.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    context
                                        .read<GroupInfoCubitCubit>()
                                        .updateGroup(snapshot.data);
                                    if (snapshot.data?.docs.length == 0) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 280,
                                          ),
                                          Text(
                                              'oops, bạn chưa có nhóm nào :(('),
                                        ],
                                      );
                                    }

                                    return BlocBuilder<GroupInfoCubitCubit,
                                        GroupInfoCubitState>(
                                      builder: (context, state) {
                                        if (state is GroupInfoCubitLoaded) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  navigatePush(context, SearchGroup(group: (context.read<GroupInfoCubitCubit>().state as GroupInfoCubitLoaded).groupinfo!));
                                                },
                                                child: Container(
                                                  height: 45,
                                                  margin: EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 15,
                                                      right: 15),
                                                  // padding:
                                                  //     EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.35),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                        prefixIcon:
                                                            Icon(Icons.search),
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Nhập để tìm kiếm nhóm đã tham gia'),
                                                  ),
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                reverse: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    state.groupinfo!.length,
                                                itemBuilder: (context, index) {
                                                  return messagerow(
                                                      state.groupinfo![index],
                                                      index);
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    );
                                  }
                                  // return Center(
                                  //   child: CircularProgressIndicator(),
                                  // );
                                  return Center(
                                    child:
                                        Text('oops, bạn chưa có nhóm nào :(('),
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            navigatePush(context, JoinGroup());
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          label: Center(child: FittedBox(child: Text('Tham gia nhóm'))),
        ),
      ),
    );
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Widget messagerow(GroupInfo group, int ind) {
    return GestureDetector(
      onTap: () {
        context.read<GroupInfoCubitCubit>().setFalse();
        navigatePush(
            context,
            chatDetail(
              groupId: group.groupId.toString(),
              groupName: group.groupName.toString(),
              members: group.members!,
              admininfo: group.admin!,
            ));
      },
      onLongPress: () {},
      child: Stack(
        children: [
          Container(
            width: screenwidth,
            height: 55,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            color: Colors.transparent,
            child: Row(
              children: [
                CircleAvatar(
                  minRadius: 30,
                  child: Container(
                    child: Center(
                      child: Text(group.groupName.toString().substring(0, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  // width: screenwidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.groupName.toString(),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontWeight: group.checkIsRead!
                                ? FontWeight.w400
                                : FontWeight.w600),
                      ),
                      Row(mainAxisSize: MainAxisSize.max, children: [
                        group.type == Type.announce
                            ? SizedBox()
                            : Text(
                                group.recentMessageSender != null &&
                                        group.recentMessageSender
                                            .toString()
                                            .isNotEmpty
                                    ? Userinfo.userSingleton.uid ==
                                            group.recentMessageSender
                                                .toString()
                                                .substring(group
                                                        .recentMessageSender
                                                        .toString()
                                                        .length -
                                                    28)
                                        ? 'Bạn:'
                                        : '${group.recentMessageSender.toString().substring(0, group.recentMessageSender.toString().length - 29)}:'
                                    : 'Chưa có tin nhắn nào',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: group.checkIsRead!
                                        ? FontWeight.w400
                                        : FontWeight.w600),
                              ),
                        Flexible(
                          // width: 200,
                          child: group.type == Type.announce
                              ? Text(
                                  group.recentMessageSender ==
                                          Userinfo.userSingleton.name
                                      ? 'bạn ${group.recentMessage.toString()}'
                                      : '${group.recentMessageSender} ${group.recentMessage.toString()}',
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: group.checkIsRead!
                                          ? FontWeight.w400
                                          : FontWeight.w600),
                                )
                              : Text(
                                  group.recentMessage != null
                                      ? '${group.recentMessage.toString()}'
                                      : '',
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: group.checkIsRead!
                                          ? FontWeight.w400
                                          : FontWeight.w600),
                                ),
                        ),
                        Text('  '),
                        Text(
                          group.time == null || group.time.toString().isEmpty
                              ? ''
                              : '${DateTime.fromMicrosecondsSinceEpoch(int.parse(group.time!)).toString().split(' ').last.substring(0, 5)}',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: group.checkIsRead!
                                  ? FontWeight.w400
                                  : FontWeight.w600),
                        )
                      ])
                    ],
                  ),
                ),
                // Spacer(),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          context
                              .read<GroupInfoCubitCubit>()
                              .chooseItemToShow(ind);
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black54,
                        )))
              ],
            ),
          ),
          group.checked!
              ? Positioned(
                  right: 50,
                  top: 20,
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: group.inviteId))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Invite id copied to clipboard: ${group.inviteId}"),
                          duration: Duration(seconds: 2),
                        ));
                      });
                      context.read<GroupInfoCubitCubit>().setFalse();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(color: Colors.pink, boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            spreadRadius: 0.1,
                            color: Colors.grey.withOpacity(0.2))
                      ]),
                      child: Text('Copy invite id'),
                    ),
                  ))
              : SizedBox()
        ],
      ),
    );
  }
}

class buttonicon extends StatelessWidget {
  buttonicon({Key? key, required this.icon, required this.click})
      : super(key: key);
  IconData icon;
  VoidCallback click;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: IconButton(
          onPressed: click,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
