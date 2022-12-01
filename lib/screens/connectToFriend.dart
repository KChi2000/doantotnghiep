import 'dart:math';

import 'package:doantotnghiep/bloc/getInviteId/get_invite_id_cubit.dart';
import 'package:doantotnghiep/bloc/showBoxInviteId/show_box_invite_id_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:doantotnghiep/screens/SearchAndJoined.dart';
import 'package:doantotnghiep/screens/chatDetail.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectToFriend extends StatefulWidget {
  ConnectToFriend({super.key});

  @override
  State<ConnectToFriend> createState() => _ConnectToFriendState();
}

class _ConnectToFriendState extends State<ConnectToFriend> {
  var groupNameCon = TextEditingController();

  var formkey = GlobalKey<FormState>();
  Stream? group = null;
  loadGroups() async {
    await DatabaseService(uid: Userinfo.userSingleton.uid)
        .getUserGroups()
        .then((value) {
      setState(() {
        group = value;
      });
    });
  }

  @override
  void initState() {
    loadGroups();
    super.initState();
    checkShowCopyInviteBox(false);
  }

  void checkShowCopyInviteBox(bool vl) {
    context.read<ShowBoxInviteIdCubit>().set(vl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      return AlertDialog(
                        title: Text('Create group'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Copy mã bên dưới để mời bạn bè tham gia vào nhóm'),
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
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Clipboard.setData(
                                                ClipboardData(text: invitedId))
                                            .then((_) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Invite id copied to clipboard: $invitedId"),
                                            duration: Duration(seconds: 2),
                                          ));
                                        });
                                      },
                                      icon: Icon(
                                        Icons.copy,
                                        color: Colors.black54,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                          TextButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  String? username =
                                      await HelperFunctions.getLoggedUserName();
                                  await DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid,
                                  ).CreateGroup(
                                      groupNameCon.text,
                                      FirebaseAuth.instance.currentUser!.uid,
                                      username!,
                                      invitedId);
                                  print('create group thanh cong');
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Create'))
                        ],
                      );
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
          checkShowCopyInviteBox(false);
        },
        child: Container(
          width: screenwidth,
          height: screenheight,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          navigatePush(context, SearchAndJoined());
                        },
                        child: Container(
                          height: 45,
                          margin:
                              EdgeInsets.only(bottom: 10, left: 15, right: 15),
                          // padding:
                          //     EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                hintText: 'Tìm kiếm hoặc nhập mã'),
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: group,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data['groups'].length == 0) {
                                return Center(
                                  child: Text('oops, bạn chưa có nhóm nào :(('),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data['groups'].length,
                                itemBuilder: (context, index) {
                                  context.read<GetInviteIdCubit>().getInviteid(
                                      snapshot.data['groups'][index]
                                          ['groupId']);
                                          print(snapshot.data['groups'][index]
                                          ['recentMessageSender']);
                                  return messagerow(
                                      snapshot.data['groups'][index]
                                          ['GroupName'],
                                      snapshot.data['groups'][index]['groupId'],
                                      snapshot.data['groups'][index]
                                          ['recentMessageSender'],
                                      snapshot.data['groups'][index]
                                          ['recentMessage']);
                                },
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Widget messagerow(String groupname, String grId, String recentsendername,
      String recentsenderMessage) {
    return GestureDetector(
      onTap: () {
        navigatePush(context, chatDetail(groupId: grId, groupName: groupname));
      },
      onLongPress: () {
        print('nhả ra mau');
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            color: Colors.transparent,
            child: Row(
              children: [
                CircleAvatar(
                  minRadius: 30,
                  child: Container(
                    child: Center(
                      child: Text(groupname.substring(0, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupname,
                      style: TextStyle(color: Colors.black87, fontSize: 17),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: recentsendername.substring(0,recentsendername.length-29),
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      TextSpan(
                        text: recentsenderMessage,
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      TextSpan(
                        text: ' 7:20',
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      )
                    ]))
                  ],
                ),
                Spacer(),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          bool vl =
                              context.read<ShowBoxInviteIdCubit>().state.show;
                          checkShowCopyInviteBox(!vl);
                        },
                        icon: Icon(Icons.more_vert)))
              ],
            ),
          ),
          BlocBuilder<ShowBoxInviteIdCubit, ShowBoxInviteIdState>(
            builder: (context, state) {
              if (!state.show) {
                return SizedBox();
              }
              return BlocBuilder<GetInviteIdCubit, GetInviteIdState>(
                builder: (context, state) {
                  return Positioned(
                      right: 50,
                      top: 20,
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: state.inviteid))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Invite id copied to clipboard: ${state.inviteid}"),
                              duration: Duration(seconds: 2),
                            ));
                          });
                          checkShowCopyInviteBox(false);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    spreadRadius: 0.1,
                                    color: Colors.grey.withOpacity(0.2))
                              ]),
                          child: Text('Copy invite id'),
                        ),
                      ));
                },
              );
            },
          )
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
