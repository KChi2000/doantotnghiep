import 'dart:math';

import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/screens/SearchAndJoined.dart';
import 'package:doantotnghiep/screens/chatDetail.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
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
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.copy,
                                        color: Colors.black87,
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
      body: Container(
        width: screenwidth,
        height: screenheight,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 10,
            //     ),
            //     CircleAvatar(
            //       minRadius: 40,
            //       child: Container(),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Text(
            //       'Message',
            //       style: TextStyle(fontSize: 40),
            //     ),
            //     // buttonicon(
            //     //   icon: Icons.camera_alt,
            //     //   click: () {},
            //     // ),
            //     Spacer(),
            //     buttonicon(
            //       icon: Icons.group_add_rounded,
            //       click: () {
            //         String invitedId = getRandomString(6);
            //         groupNameCon.clear();
            //         showDialog(
            //             context: context,
            //             builder: (context) {
            //               return AlertDialog(
            //                 title: Text('Create group'),
            //                 content: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     Form(
            //                       key: formkey,
            //                       child: TextFormField(
            //                         controller: groupNameCon,
            //                         decoration: InputDecoration(
            //                             hintText: 'group\'s name',
            //                             isDense: true,
            //                             border: OutlineInputBorder()),
            //                         validator: (value) {
            //                           if (groupNameCon.text.isEmpty ||
            //                               groupNameCon.text.length == 0) {
            //                             return 'Tên nhóm không được để trống';
            //                           }
            //                           return null;
            //                         },
            //                         autovalidateMode:
            //                             AutovalidateMode.onUserInteraction,
            //                       ),
            //                     ),
            //                     SizedBox(
            //                       height: 5,
            //                     ),
            //                     Text(
            //                         'Copy mã bên dưới để mời bạn bè tham gia vào nhóm'),
            //                     Container(
            //                       height: 40,
            //                       width: 300,
            //                       padding: EdgeInsets.only(left: 10),
            //                       color: Colors.grey.withOpacity(0.3),
            //                       child: Row(
            //                         mainAxisSize: MainAxisSize.min,
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Text(
            //                             invitedId,
            //                             style: TextStyle(
            //                                 fontSize: 16,
            //                                 color: Colors.black87),
            //                           ),
            //                           IconButton(
            //                               onPressed: () {},
            //                               icon: Icon(
            //                                 Icons.copy,
            //                                 color: Colors.black87,
            //                               ))
            //                         ],
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //                 actions: [
            //                   TextButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       },
            //                       child: Text('Cancel')),
            //                   TextButton(
            //                       onPressed: () async {
            //                         if (formkey.currentState!.validate()) {
            //                           String? username = await HelperFunctions
            //                               .getLoggedUserName();
            //                           await DatabaseService(
            //                             uid: FirebaseAuth
            //                                 .instance.currentUser!.uid,
            //                           ).CreateGroup(
            //                               groupNameCon.text,
            //                               FirebaseAuth
            //                                   .instance.currentUser!.uid,
            //                               username!,
            //                               invitedId);
            //                           print('create group thanh cong');
            //                           Navigator.pop(context);
            //                         }
            //                       },
            //                       child: Text('Create'))
            //                 ],
            //               );
            //             });
            //       },
            //     ),
            //     SizedBox(
            //       width: 15,
            //     ),
            //   ],
            // ),
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
                                return messagerow(snapshot.data['groups'][index]
                                    ['GroupName']);
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
    );
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Widget messagerow(String groupname) {
    return GestureDetector(
      onTap: () {
        navigatePush(
            context,
            chatDetail(
                groupId: '', groupName: groupname, userId: '', userName: ''));
      },
      onLongPress: () {
        print('nhả ra mau');
      },
      child: Container(
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
                    text: 'You:',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  TextSpan(
                    text: 'How are u doin\'?',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  TextSpan(
                    text: ' 7:20',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  )
                ]))
              ],
            )
          ],
        ),
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
