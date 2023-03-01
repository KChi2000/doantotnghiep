import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/canCreateGroup/can_create_group_cubit.dart';
import 'package:doantotnghiep/bloc/createGroup/create_group_cubit.dart';
import 'package:doantotnghiep/bloc/getInviteId/get_invite_id_cubit.dart';
import 'package:doantotnghiep/bloc/getUserGroup/get_user_group_cubit.dart';
import 'package:doantotnghiep/bloc/showBoxInviteId/show_box_invite_id_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:doantotnghiep/screens/Chat/CallAudio.dart';
import 'package:doantotnghiep/screens/Chat/CallVideo.dart';
import 'package:doantotnghiep/screens/Chat/IncomingCall.dart';

import 'package:doantotnghiep/screens/Chat/JoinGroup.dart';
import 'package:doantotnghiep/screens/Chat/SearchGroup.dart';
import 'package:doantotnghiep/screens/auth/Quenmatkhau.dart';
import 'package:doantotnghiep/screens/Chat/chatDetail.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rive/rive.dart';

import '../../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../../bloc/JoinStatus/join_status_cubit.dart';
import '../../bloc/TimKiemGroup/tim_kiem_group_cubit.dart';
import '../../bloc/fetchLocationToShow/fetch_location_to_show_cubit.dart';
import '../../bloc/getProfile/get_profile_cubit.dart';
import '../../model/User.dart';

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
  }

  @override
  Widget build(BuildContext ct) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.6,
      overlayWidget: Center(child: CircularProgressIndicator()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 3,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: .0),
              child: IconButton(
                icon: Icon(
                  Icons.group_add_rounded,
                  color: Colors.black,
                ),
                onPressed: () async {
                  await context.read<CreateGroupCubit>().createInviteId();
                  groupNameCon.clear();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child:
                              BlocBuilder<CreateGroupCubit, CreateGroupState>(
                            builder: (context, state) {
                              return Container(
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
                                                    color: Colors.black),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Form(
                                            key: formkey,
                                            child: TextFormField(
                                              controller: groupNameCon,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              cursorColor: Colors.grey,
                                              decoration: InputDecoration(
                                                  hintText: 'group\'s name',
                                                  isDense: true,
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black))),
                                              validator: (value) {
                                                if (groupNameCon.text.isEmpty ||
                                                    groupNameCon.text.length ==
                                                        0) {
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
                                                color: Colors.black),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  state.inviteid,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                              ClipboardData(
                                                                  text: state
                                                                      .inviteid))
                                                          .then((_) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "Invite id copied to clipboard: ${state.inviteid}"),
                                                          duration: Duration(
                                                              seconds: 2),
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
                                                    context
                                                        .read<
                                                            CanCreateGroupCubit>()
                                                        .toggleFalse();
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
                                                      context
                                                          .read<
                                                              CanCreateGroupCubit>()
                                                          .toggleTrue();
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
                              );
                            },
                          ),
                        );
                      }).whenComplete(() async {
                    if (context.read<CanCreateGroupCubit>().state.canCreate) {
                      if (formkey.currentState!.validate()) {
                        context.loaderOverlay.show();
                        context
                            .read<CreateGroupCubit>()
                            .creategroup(groupNameCon.text.trim());

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
                    }
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
              Expanded(
                child: SingleChildScrollView(
                  child: BlocBuilder<GetUserGroupCubit, GetUserGroupState>(
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
                                    Text('oops, bạn chưa có nhóm nào :(('),
                                  ],
                                );
                              }

                              return BlocConsumer<GroupInfoCubitCubit,
                                  GroupInfoCubitState>(
                                listener: (context, state) {
                                  if (state is GroupInfoCubitLoaded) {
                                    state.groupinfo!.forEach((element) async {
                                      if (element.callStatus == 'calling' &&
                                          element.recentMessageSender
                                                  .toString()
                                                  .substring(
                                                      element.recentMessageSender
                                                              .toString()
                                                              .length -
                                                          29,
                                                      element
                                                          .recentMessageSender
                                                          .toString()
                                                          .length) !=
                                              Userinfo.userSingleton.uid) {
                                        listenerEvent(ct);
                                        await FlutterCallkitIncoming
                                            .showCallkitIncoming(Callparam(
                                                '${element.groupId}',
                                                '${element.groupName}',
                                                element.type == Type.callvideo
                                                    ? 'video'
                                                    : 'audio'));
                                      } else if(element.callStatus == 'call end'){
                                         await FlutterCallkitIncoming.endCall(element.groupId.toString());
                                        // Fluttertoast.showToast(
                                        // msg: "Tat may roi",
                                        // toastLength: Toast.LENGTH_SHORT,
                                        // gravity: ToastGravity.BOTTOM,
                                        // timeInSecForIosWeb: 1,
                                        // textColor: Colors.white,
                                        // backgroundColor: Colors.pink,
                                        // fontSize: 16.0);
                                      }
                                    });
                                  }
                                },
                                builder: (context, state) {
                                  if (state is GroupInfoCubitLoaded) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            navigatePush(
                                                context,
                                                SearchGroup(
                                                    group: (context
                                                                .read<
                                                                    GroupInfoCubitCubit>()
                                                                .state
                                                            as GroupInfoCubitLoaded)
                                                        .groupinfo!));
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
                                                    BorderRadius.circular(30)),
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
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
                                          itemCount: state.groupinfo!.length,
                                          itemBuilder: (context, index) {
                                            context
                                                .read<
                                                    FetchLocationToShowCubit>()
                                                .fetchFromDb(
                                                    state.groupinfo![index]);
                                            return groupitem(
                                                state.groupinfo![index],
                                                ct,
                                                true);
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
                              child: Text('oops, bạn chưa có nhóm nào ((:'),
                            );
                          });
                    },
                  ),
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
          label: Center(
              child: FittedBox(
                  child: Text(
            'Tham gia nhóm',
            style: TextStyle(color: Colors.white),
          ))),
        ),
      ),
    );
  }

  Future<void> listenerEvent(context) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      FlutterCallkitIncoming.onEvent.listen((event) {
        if (!mounted) return;
        switch (event!.event) {
          case Event.ACTION_CALL_INCOMING:
            print('ACTION_CALL_INCOMING');
            break;
          case Event.ACTION_CALL_START:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            break;
          case Event.ACTION_CALL_ACCEPT:
            print(
                'ACTION_CALL_ACCEPT ${(event.body as Map<String, dynamic>)['id'].toString().substring(5)}');
            // (event.body as Map<String, dynamic>)['id']
            //             .toString()
            //             .substring(0, 5) ==
            //         'video'
            //     ? 
            Future.delayed(Duration.zero, () {
                    navigatePush(
                        context,
                        CallVideo(
                          groupid: (event.body as Map<String, dynamic>)['id'].toString().substring(5)
                             ,
                          grname: (event.body
                              as Map<String, dynamic>)['nameCaller'],
                          answere: true,
                        ));
                  });
            //     : Future.delayed(Duration.zero, () {
            //         navigatePush(
            //             context,
            //             CallAudio(
            //               groupid: (event.body as Map<String, dynamic>)['id']
            //                   .toString()
            //                   .substring(5),
            //               grname: (event.body
            //                   as Map<String, dynamic>)['nameCaller'],
            //               answere: true,
            //             ));
            //       });

            break;
          case Event.ACTION_CALL_DECLINE:
            print('ACTION_CALL_DECLINE');
            break;
          case Event.ACTION_CALL_ENDED:
            // TODO: ended an incoming/outgoing call
            break;
          case Event.ACTION_CALL_TIMEOUT:
            // TODO: missed an incoming call
            break;
          case Event.ACTION_CALL_CALLBACK:
            // TODO: only Android - click action `Call back` from missed call notification
            break;
          case Event.ACTION_CALL_TOGGLE_HOLD:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_MUTE:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_DMTF:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_GROUP:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
            // TODO: only iOS
            break;
        }
      });
    } on Exception {}
  }

  Callparam(String grid, String grname, String typeOfcall) {
    return CallKitParams(
      id: '$typeOfcall$grid',
      nameCaller: 'Nhóm $grname',
      appName: 'Cùng Phượt',
      avatar: 'assets/images/Cùng Phượt.png',
      handle: 'đang gọi $typeOfcall',
      type: 0,
      duration: 30000,
      textAccept: 'Trả lời',
      textDecline: 'Từ chối',
      textMissedCall: 'Cuộc gọi nhỡ',
      textCallback: 'Gọi lại',
      extra: <String, dynamic>{'userId': '${Userinfo.userSingleton.uid}'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: AndroidParams(
        isCustomNotification: true,
        // isShowLogo: true,
        isShowCallback: true,
        isShowMissedCallNotification: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
      ),
      ios: IOSParams(
        iconName: 'Cùng Phượt',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
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

class groupitem extends StatelessWidget {
  groupitem(this.group, this.ct, this.margin, {this.focusNode});
  GroupInfo group;
  BuildContext ct;
  bool margin;
  FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: group.status == 'deleted'
          ? null
          : () {
              Future.delayed(Duration.zero, () {
                navigateReplacement(
                    context,
                    chatDetail(
                      group: group,
                    ));
              });
            },
      onLongPress: () {},
      child: Stack(
        children: [
          Container(
            width: screenwidth,
            height: 55,
            margin: margin
                ? EdgeInsets.only(left: 10, right: 10, bottom: 10)
                : EdgeInsets.all(0),
            color: Colors.transparent,
            child: Row(
              children: [
                CircleAvatar(
                  minRadius: 30,
                  child: Container(
                    child: Center(
                      child: Text(
                        group.groupName.toString().substring(0, 1),
                        style: TextStyle(color: Colors.white),
                      ),
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
                            color: group.status == 'deleted'
                                ? Colors.grey
                                : Colors.black87,
                            fontSize: 17,
                            fontWeight: group.status == 'deleted'
                                ? FontWeight.normal
                                : group.checkIsRead!
                                    ? FontWeight.w400
                                    : FontWeight.w600),
                      ),
                      group.status == 'deleted'
                          ? Text(
                              Userinfo.userSingleton.uid ==
                                      group.admin!.adminId.toString()
                                  ? 'Nhóm đã bị xóa bởi bạn'
                                  : 'Nhóm đã bị xóa bởi Admin',
                              style: TextStyle(color: Colors.grey),
                            )
                          : Row(mainAxisSize: MainAxisSize.max, children: [
                              group.type == Type.announce
                                  ? SizedBox()
                                  : Text(
                                      group.type != Type.announce
                                          ? Userinfo.userSingleton.uid ==
                                                  group.recentMessageSender
                                                      .toString()
                                                      .substring(group
                                                              .recentMessageSender
                                                              .toString()
                                                              .length -
                                                          28)
                                              ? 'Bạn: '
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
                                            : group.recentMessageSender
                                                        .toString()
                                                        .isEmpty ||
                                                    group.recentMessageSender ==
                                                        null
                                                ? '${group.recentMessage.toString()}'
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
                              group.recentMessageSender.toString().isEmpty ||
                                      group.recentMessageSender == null
                                  ? SizedBox()
                                  : Text(
                                      group.time == null ||
                                              group.time.toString().isEmpty
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
                group.status == 'deleted'
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton(
                            offset: Offset(-30, 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            elevation: 10,
                            padding: EdgeInsets.all(0),
                            surfaceTintColor: Colors.white,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  onTap: () {
                                    focusNode?.unfocus();
                                    Clipboard.setData(
                                            ClipboardData(text: group.inviteId))
                                        .then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Invite id copied to clipboard: ${group.inviteId}"),
                                        duration: Duration(seconds: 2),
                                      ));
                                    });
                                  },
                                  child: Text(
                                    'Copy inviteid',
                                    style: TextStyle(color: Colors.pink),
                                  ),
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10),
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'roboto'),
                                ),
                                PopupMenuItem(
                                  onTap: () async {
                                    if (Userinfo.userSingleton.uid !=
                                        group.admin!.adminId.toString()) {
                                      Future.delayed(
                                        const Duration(seconds: 0),
                                        () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            title: Text(
                                                'Bạn có chắc muốn rời nhóm?'),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Hủy')),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    ct.loaderOverlay.show();
                                                    await context
                                                        .read<
                                                            JoindStatusCubit>()
                                                        .leaveGroup(
                                                            group.groupId
                                                                .toString(),
                                                            group.groupName
                                                                .toString());
                                                    ct.loaderOverlay.hide();
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Đã rời nhóm thành công",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.white,
                                                        backgroundColor:
                                                            Colors.pink,
                                                        fontSize: 16.0);
                                                  },
                                                  child: Text('Xác nhận'))
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      Future.delayed(
                                        const Duration(seconds: 0),
                                        () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            title: Text(
                                                'Bạn có chắc muốn xóa nhóm?'),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Hủy')),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    ct.loaderOverlay.show();
                                                    await context
                                                        .read<
                                                            JoindStatusCubit>()
                                                        .deleteGroup(
                                                            group.groupId
                                                                .toString(),
                                                            group.groupName
                                                                .toString());
                                                    ct.loaderOverlay.hide();
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Đã rời xóa thành công",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.white,
                                                        backgroundColor:
                                                            Colors.pink,
                                                        fontSize: 16.0);
                                                  },
                                                  child: Text('Xác nhận'))
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                      Userinfo.userSingleton.uid ==
                                              group.admin!.adminId.toString()
                                          ? 'Xoá nhóm'
                                          : 'Rời nhóm',
                                      style: TextStyle(color: Colors.pink)),
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10),
                                  // height: 20,
                                  textStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                )
                              ];
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.black54,
                            )))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0.0);
    path.quadraticBezierTo(2, 2, 0, size.height / 2);
    path.quadraticBezierTo(0, size.height - 20, 10, size.height - 10);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width - 10, size.height - 10);
    path.quadraticBezierTo(
        size.width, size.height - 20, size.width, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.quadraticBezierTo(size.width - 2, 2, size.width / 2, 0.0);
    path.close();
    return path;
    // Path path = Path();
    // path.addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2));
    // path.lineTo(size.width/2, size.height);
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class customMarker extends StatelessWidget {
  customMarker(this.globalKeyMyWidget);
  final GlobalKey globalKeyMyWidget;
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: SizedBox(
        width: 60,
        height: 60,
        child: ClipPath(
          child: Container(
              padding: EdgeInsets.all(5),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/Cùng Phượt.png'),
              )),
          clipper: CustomClipPath(),
        ),
      ),
    );
  }
}
