import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/ChangeMessageStatus/change_message_status_cubit.dart';
import 'package:doantotnghiep/bloc/MessageCubit/message_cubit_cubit.dart';
import 'package:doantotnghiep/bloc/SendMessage/send_message_cubit.dart';
import 'package:doantotnghiep/bloc/getChatMessage/get_chat_message_cubit.dart';
import 'package:doantotnghiep/bloc/noticeCalling/notice_calling_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/helper/location_notofications.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:doantotnghiep/helper/Signaling.dart';
import 'package:doantotnghiep/screens/Chat/CallAudio.dart';

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
import '../../bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import '../../bloc/fetchLocationToShow/fetch_location_to_show_cubit.dart';
import '../../bloc/getUserGroup/get_user_group_cubit.dart';
import '../../components/ItemMessage.dart';
import '../../components/ItemThanhVien.dart';
import '../../components/callItem.dart';
import '../../model/Group.dart';
import '../../model/User.dart';

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

class _chatDetailState extends State<chatDetail> with WidgetsBindingObserver {
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
    context.read<FetchLocationToShowCubit>().fetchFromDb(widget.group);
    context.read<SendMessageCubit>().initialStatusSendMessage();
    messageFireBase();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.resumed) {
      print('in the chat detail');
    } else {
      print('not in th chat detail');
    }
  }
  messageFireBase(){
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      print('FB message when app terminated:\n${value!.notification!.title} ${value!.notification!.body}');
    });
    FirebaseMessaging.onMessage.listen((value) {
      print('FB message in foreground:\n${value!.notification!.title} ${value!.notification!.body}');
      LocalNotificationService.showNotificationOnForeground(value);
    });
     FirebaseMessaging.onMessageOpenedApp.listen((value) {
      print('FB message in background:\n${value!.notification!.title} ${value!.notification!.body}');
    });
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(
                  onPressed: () async {
                    Future.delayed(Duration.zero, () {
                      navigatePush(
                          context,
                          CallAudio(
                            groupid: widget.group.groupId.toString(),
                            grname: widget.group.groupName.toString(),
                            answere: false,
                          ));
                    });
                  },
                  icon: Icon(Icons.call)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(
                  onPressed: () async {
                     FlutterRingtonePlayer.playRingtone();
                    context
                        .read<NoticeCallingCubit>()
                        .notificationCalling(true);
                   
                    // Future.delayed(Duration.zero, () {
                    //   navigatePush(
                    //       context,
                    //       CallVideo(
                    //         groupid: widget.group.groupId.toString(),
                    //         grname: widget.group.groupName.toString(),
                    //         answere: false,
                    //       ));
                    // });
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
                                  'Thành viên(${widget.group.members!.length})'),
                              content: Container(
                                constraints: BoxConstraints(
                                    minHeight: 80, maxHeight: 200),
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
                          if (snapshot.data!.docChanges.length != 0) {
                            DatabaseService().updateisReadMessage(
                                widget.group.groupId!.toString());
                          }
                          context
                              .read<MessageCubitCubit>()
                              .DisplayMessage(snapshot);
                          return BlocConsumer<MessageCubitCubit,
                              MessageCubitState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              return Expanded(
                                child: ListView.builder(
                                  controller: listController,
                                  shrinkWrap: true,
                                  itemCount: state.list!.length,
                                  itemBuilder: (context, index) {
                                    return BlocBuilder<FetchLocationToShowCubit,
                                        FetchLocationToShowState>(
                                      builder: (context, stateUser) {
                                        if (stateUser
                                            is FetchLocationToShowLoaded) {
                                     
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
                              );
                            },
                          );
                        });
                  },
                ),
                SizedBox(height: 10,),
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
                            hintText: 'send a message...',
                            hintStyle: TextStyle(color: Colors.grey)),
                        onFieldSubmitted: (value) async {
                          await context.read<SendMessageCubit>().sendmessage(
                              widget.group.groupId!.toString(),
                              Message(
                                  sender:
                                      '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                                  contentMessage: messageController.text.trim(),
                                  time: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  type: Type.text));
                          // await FirebaseMessaging.instance.sendMessage({
                            
                          // });
                          messageController.clear();
                        },
                      )),
                      IconButton(
                          onPressed: () async {
                            await context.read<SendMessageCubit>().sendmessage(
                                widget.group.groupId!.toString(),
                                Message(
                                    sender:
                                        '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                                    contentMessage:
                                        messageController.text.trim(),
                                    time: DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                    type: Type.text));
                            messageController.clear();
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.pink,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget messagestatus(String status, int index, int length) {
    if (index == length - 1) {
      return Text(status,
          style: TextStyle(fontSize: 11, color: Colors.black54));
    }
    return SizedBox();
  }
}
