import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/ChangeMessageStatus/change_message_status_cubit.dart';
import 'package:doantotnghiep/bloc/MessageCubit/message_cubit_cubit.dart';
import 'package:doantotnghiep/bloc/SendMessage/send_message_cubit.dart';
import 'package:doantotnghiep/bloc/getChatMessage/get_chat_message_cubit.dart';
import 'package:doantotnghiep/bloc/getPicGroupMember/get_pic_group_member_cubit.dart';
import 'package:doantotnghiep/bloc/noticeCalling/notice_calling_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/location_notofications.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:doantotnghiep/helper/Signaling.dart';
import 'package:doantotnghiep/screens/Chat/CallAudio.dart';
import 'package:http/http.dart' as http;
import 'package:doantotnghiep/screens/Chat/CallVideo.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/screens/DisplayPage.dart';
import 'package:doantotnghiep/screens/Chat/connectToFriend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../../bloc/Changetab/changetab_cubit.dart';
import '../../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../../bloc/MakeAVideoCall/make_a_video_call_cubit.dart';

import '../../bloc/fetchLocationToShow/fetch_location_to_show_cubit.dart';
import '../../bloc/getPicGroupMember/check_can_display_notification_cubit.dart';
import '../../bloc/getUserGroup/get_user_group_cubit.dart';
import '../../bloc/pushNotification/push_notification_cubit.dart';
import '../../components/ItemMessage.dart';
import '../../components/ItemThanhVien.dart';
import '../../components/callItem.dart';
import '../../main.dart';
import '../../model/Group.dart';
import '../../model/User.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class chatDetail extends StatefulWidget {
  chatDetail({
    super.key,
    required this.group,
  });

  //List<Members> members;
  GroupInfo group;
  @override
  State<chatDetail> createState() => _chatDetailState();
}

class _chatDetailState extends State<chatDetail> with RouteAware {
  var listController = ScrollController();
  var messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LocalNotificationService.initialize();
    context
        .read<GetChatMessageCubit>()
        .fetchData(widget.group.groupId.toString());
    context.read<GetPicGroupMemberCubit>().fetchFromDb(widget.group);
    context.read<SendMessageCubit>().initialStatusSendMessage();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // TODO: implement didChangeAppLifecycleState
  //   if (state == AppLifecycleState.resumed) {
  //     print('in the chat detail');
  //   } else {
  //     print('not in th chat detail');
  //   }
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    context
        .read<CheckCanDisplayNotificationCubit>()
        .canDisplayNotification(false);
    super.didPush();
  }

  @override
  void didPop() {
    super.didPop();
  }

  @override
  void didPopNext() {}

  @override
  void didPushNext() {
    // TODO: implement didPushNext
    super.didPushNext();

    context
        .read<CheckCanDisplayNotificationCubit>()
        .canDisplayNotification(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            widget.group.groupName.toString(),
          ),
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              context.read<ChangetabCubit>().change(1);
              navigateReplacement(context, DisplayPage());
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            widget.group.members!.length == 1
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: IconButton(
                        onPressed: () async {
                          await DatabaseService()
                              .refreshCallStatus(
                                  widget.group.groupId.toString())
                              .then((value) => {
                                    Future.delayed(Duration.zero, () {
                                      navigatePush(
                                          context,
                                          CallAudio(
                                            groupid:
                                                widget.group.groupId.toString(),
                                            grname: widget.group.groupName
                                                .toString(),
                                            answere: false,
                                          ));
                                    })
                                  });
                          await context
                              .read<PushNotificationCubit>()
                              .pushCallNoti(
                                  widget.group, 'audio', widget.group.toJson());
                        },
                        icon: Icon(Icons.call)),
                  ),
            widget.group.members!.length == 1
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: IconButton(
                        onPressed: () async {
                          // FlutterRingtonePlayer.playRingtone();
                          await DatabaseService()
                              .refreshCallStatus(
                                  widget.group.groupId.toString())
                              .then((value) => {
                                    Future.delayed(Duration.zero, () {
                                      navigatePush(
                                          context,
                                          CallVideo(
                                            groupid:
                                                widget.group.groupId.toString(),
                                            grname: widget.group.groupName
                                                .toString(),
                                            answere: false,
                                          ));
                                    })
                                    
                                  });
                                  await context
                              .read<PushNotificationCubit>()
                              .pushCallNoti(
                                  widget.group, 'video', widget.group.toJson());
                        },
                        icon: Icon(Icons.videocam)),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              title: Text(
                                  'Thành viên (${widget.group.members!.length})'),
                              content: Container(
                                constraints: BoxConstraints(
                                    minHeight: 30, maxHeight: 200),
                                width: 100,
                                color: Colors.white,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.group.members!.length,
                                  itemBuilder: (context, index) {
                                    return ItemThanhVien(
                                        widget.group.members![index],
                                        index,
                                        widget.group.admin!.adminId.toString(),
                                        widget.group.members!.length);
                                  },
                                ),
                              ),
                            ));
                  },
                  icon: Icon(Icons.info)),
            )
          ],
        ),
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
            context.read<MessageCubitCubit>().unshowMsgTime();
          },
          child: Container(
            width: screenwidth,
            height: screenheight,
            padding: EdgeInsets.only(top: 10),
            color: Colors.grey.withOpacity(0.2),
            child: Column(
              children: [
                BlocBuilder<GetChatMessageCubit, GetChatMessageState>(
                  builder: (context, state) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: state.data,
                        builder: (context, snapshot) {
                          // state.data!.listen((event) {
                          //   DatabaseService().updateisReadMessage(widget.groupId);
                          // });

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Expanded(
                                child: Center(
                              child: CircularProgressIndicator(),
                            ));
                          }
                          if (snapshot.data!.docs.length == 0) {
                            return Expanded(
                                child: Center(
                                    child: Text(
                                        'Hãy nhắn gì đó cho các bạn của bạn nào ((:')));
                          }
                          // if (snapshot.data!.docChanges.length != 0) {
                          //   DatabaseService().updateisReadMessage(
                          //       widget.group.groupId!.toString());
                          // }

                          context
                              .read<MessageCubitCubit>()
                              .DisplayMessage(snapshot);
                          DatabaseService().updateisReadMessage(
                              widget.group.groupId.toString());
                          return BlocConsumer<MessageCubitCubit,
                              MessageCubitState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              return Expanded(
                                child: SingleChildScrollView(
                                  reverse: true,
                                  child: ListView.builder(
                                    controller: listController,
                                    shrinkWrap: true,
                                    itemCount: state.list!.length,
                                    itemBuilder: (context, index) {
                                      return BlocConsumer<
                                          GetPicGroupMemberCubit,
                                          GetPicGroupMemberState>(
                                        listener: (context, state) {
                                          if (state
                                              is GetPicGroupMemberLoaded) {
                                            listController.jumpTo(listController
                                                .position.maxScrollExtent);
                                          }
                                        },
                                        builder: (context, stateUser) {
                                          if (stateUser
                                              is GetPicGroupMemberLoaded) {
                                            return ItemMessage(
                                                list: state.list!,
                                                listUser: stateUser.list,
                                                index: index,
                                                length: state.list!.length);
                                          }
                                          return ItemMessage(
                                              list: state.list!,
                                              listUser: [],
                                              index: index,
                                              length: state.list!.length);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: screenwidth,
                  // height: 100,
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 15, bottom: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: messageController,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Send a message...',
                            hintStyle: TextStyle(color: Colors.grey)),
                        onFieldSubmitted: (value) async {
                          context.read<SendMessageCubit>().sendmessage(
                                widget.group,
                                Message(
                                    sender:
                                        '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                                    contentMessage:
                                        messageController.text.trim(),
                                    time: DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                    type: Type.text),
                              );

                          messageController.clear();
                        },
                      )),
                      IconButton(
                          onPressed: () async {
                            context.read<SendMessageCubit>().sendmessage(
                                  widget.group,
                                  Message(
                                      sender:
                                          '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                                      contentMessage:
                                          messageController.text.trim(),
                                      time: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString(),
                                      type: Type.text),
                                );

                            messageController.clear();
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.pink,
                          ))
                    ],
                  ),
                ),
              // BlocBuilder<GetUserGroupCubit, GetUserGroupState>(
              //     builder: (context, state) {
              //       return StreamBuilder<dynamic>(
              //           stream: state.stream,
              //           builder: (context, snapshot) {
              //             if (snapshot.hasData) {
              //               context
              //                   .read<GroupInfoCubitCubit>()
              //                   .updateGroup(snapshot.data);
              //             }
              //             return 
                          // BlocListener<GroupInfoCubitCubit,
                          //     GroupInfoCubitState>(
                          //   listener: (context, state) {
                          //     if (state is GroupInfoCubitLoaded) {
                          //       state.groupinfo!.forEach((element) async {
                          //         if (element.recentMessageSender
                          //                 .toString()
                          //                 .isNotEmpty &&
                          //             element.recentMessageSender.toString() !=
                          //                 null) {
                          //          if (element.callStatus ==
                          //               'call end') {
                          //             await FlutterCallkitIncoming.endAllCalls();
                          //             // endCall(
                          //             //     '${element.groupId}');
                          //           }
                          //         }
                          //       });
                          //     }
                          //   },
                          //   child: SizedBox(),
                          // ),
                //         });
                //   },
                // ),
              ],
            ),
          ),
        ));
  }

 
}
