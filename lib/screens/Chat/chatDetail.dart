import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/ChangeMessageStatus/change_message_status_cubit.dart';
import 'package:doantotnghiep/bloc/MessageCubit/message_cubit_cubit.dart';
import 'package:doantotnghiep/bloc/SendMessage/send_message_cubit.dart';
import 'package:doantotnghiep/bloc/getChatMessage/get_chat_message_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:doantotnghiep/helper/Signaling.dart';
import 'package:doantotnghiep/screens/Chat/CallAudio.dart';

import 'package:doantotnghiep/screens/Chat/CallVideo.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/screens/DisplayPage.dart';
import 'package:doantotnghiep/screens/Chat/connectToFriend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../../bloc/Changetab/changetab_cubit.dart';
import '../../bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import '../../bloc/getUserGroup/get_user_group_cubit.dart';
import '../../model/Group.dart';
import '../../model/User.dart';

class chatDetail extends StatefulWidget {
  chatDetail(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.members,
      required this.admininfo});
  String groupName;
  List<Members> members;
  Admin admininfo;
  String groupId;

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
    WidgetsBinding.instance.addObserver(this);
    context.read<GetChatMessageCubit>().fetchData(widget.groupId);
    context.read<SendMessageCubit>().initialStatusSendMessage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            widget.groupName,
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
                            groupid: widget.groupId,
                            grname: widget.groupName,
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
                    Future.delayed(Duration.zero, () {
                      navigatePush(
                          context,
                          CallVideo(
                            groupid: widget.groupId,
                            grname: widget.groupName,
                            answere: false,
                          ));
                    });
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
                              title:
                                  Text('Thành viên(${widget.members.length})'),
                              content: Container(
                                constraints: BoxConstraints(
                                    minHeight: 80, maxHeight: 200),
                                width: 100,
                                color: Colors.white,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.members.length,
                                  itemBuilder: (context, index) {
                                    return ItemThanhVien(
                                        widget.members[index], index);
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
                            DatabaseService()
                                .updateisReadMessage(widget.groupId);
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
                                    return ItemMessage(
                                        state.list!, index, state.list!.length);
                                  },
                                ),
                              );
                            },
                          );
                        });
                  },
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
                            hintText: 'send a message...',
                            hintStyle: TextStyle(color: Colors.grey)),
                        onFieldSubmitted: (value) async {
                          await context.read<SendMessageCubit>().sendmessage(
                              widget.groupId,
                              Message(
                                  sender:
                                      '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                                  contentMessage: messageController.text.trim(),
                                  time: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  type: Type.text));

                          messageController.clear();
                        },
                      )),
                      IconButton(
                          onPressed: () async {
                            await context.read<SendMessageCubit>().sendmessage(
                                widget.groupId,
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

  Widget ItemThanhVien(Members e, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.admininfo.adminId == e.Id
            ? Userinfo.userSingleton.uid == e.Id
                ? Text(
                    '${e.Name.toString()}(Bạn-Admin)',
                    style: TextStyle(fontSize: 18),
                  )
                : Text(
                    '${e.Name.toString()}(Admin)',
                    style: TextStyle(fontSize: 18),
                  )
            : Text(
                '${e.Name.toString()}',
                style: TextStyle(fontSize: 18),
              ),
        index != widget.members.length - 1
            ? Divider(
                color: Colors.grey.withOpacity(0.5),
              )
            : SizedBox(),
      ],
    );
  }

  Widget ItemMessage(List<Message> list, int index, int length) {
    return list[index].type == Type.text
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: Userinfo.userSingleton.uid ==
                    list[index].sender.substring(list[index].sender.length - 28)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              list[index].ontap
                  ? SizedBox(
                      height: 5,
                    )
                  : SizedBox(),
              list[index].ontap
                  ? Center(
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'Lúc ${list[index].displaytime}',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )))
                  : Userinfo.userSingleton.uid ==
                              list[index]
                                  .sender
                                  .substring(list[index].sender.length - 28) &&
                          index > 0 &&
                          index <= length - 1 &&
                          list[index].timesent - list[index - 1].timesent >= 3
                      ? Center(
                          child: Text(
                          '${list[index].timelocal}',
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ))
                      : SizedBox(),

              list[index].ontap
                  ? SizedBox(
                      height: 5,
                    )
                  : SizedBox(),
              index >= length - 1 && index != 0
                  ? index == length - 1 &&
                          Userinfo.userSingleton.uid !=
                              list[index]
                                  .sender
                                  .substring(list[index].sender.length - 28) &&
                          list[index].sender != list[index - 1].sender
                      ? messageText(list[index].sender, list[index].sender)
                      : list[index].timesent - list[index - 1].timesent >= 4 &&
                              Userinfo.userSingleton.uid !=
                                  list[index]
                                      .sender
                                      .substring(list[index].sender.length - 28)
                          ? messageText(list[index].sender, list[index].sender)
                          : SizedBox()
                  : Userinfo.userSingleton.uid !=
                          list[index]
                              .sender
                              .substring(list[index].sender.length - 28)
                      ? index == 0
                          ? messageText(list[index].sender, list[index].sender)
                          : list[index].sender != list[index - 1].sender
                              ? messageText(
                                  list[index].sender, list[index].sender)
                              : list[index].timesent -
                                          list[index - 1].timesent >=
                                      4
                                  ? messageText(
                                      list[index].sender, list[index].sender)
                                  : SizedBox()
                      : SizedBox(),
              GestureDetector(
                onTap: () {
                  context.read<MessageCubitCubit>().onTapMsg(index);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    index < length - 1 &&
                            Userinfo.userSingleton.uid !=
                                list[index]
                                    .sender
                                    .substring(list[index].sender.length - 28)
                        ? list[index].sender != list[index + 1].sender
                            ? itemImage(list[index].sender)
                            : list[index + 1].timesent - list[index].timesent >=
                                    4
                                ? itemImage(list[index].sender)
                                : SizedBox(
                                    width: 30,
                                  )
                        : index == length - 1 &&
                                Userinfo.userSingleton.uid !=
                                    list[index].sender.substring(
                                        list[index].sender.length - 28)
                            ? itemImage(list[index].sender)
                            : SizedBox(
                                width: 30,
                              ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: screenwidth - 150,
                        // minWidth: 50
                      ),
                      // width: screenwidth - 150,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Userinfo.userSingleton.uid ==
                                list[index]
                                    .sender
                                    .substring(list[index].sender.length - 28)
                            ? Colors.pink
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.only(bottom: 3),
                      child: Text(
                        list[index].contentMessage,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Userinfo.userSingleton.uid ==
                            list[index]
                                .sender
                                .substring(list[index].sender.length - 28)
                        ? SizedBox(
                            width: 10,
                          )
                        : SizedBox()
                  ],
                ),
              ),
              // BlocBuilder<GetUserGroupCubit, GetUserGroupState>(
              //   builder: (context, state) {
              //     return StreamBuilder(
              //         stream: state.stream,
              //         builder: (context, snapshot) {
              //           state.stream!.listen((event) {
              //             if (snapshot.hasData) {
              //               context
              //                   .read<ChangeMessageStatusCubit>()
              //                   .update(snapshot.data, widget.groupId);
              //             }
              //           });

              //           return BlocBuilder<ChangeMessageStatusCubit,
              //               ChangeMessageStatusState>(
              //             builder: (context, state) {
              //               print('list of string ${state.viewer.length}');
              //               if (state.viewer.length == 0) {
              //                 return messagestatus('đã gửi', index, length);
              //               }
              //               return messagestatus('đã xem', index, length);
              //             },
              //           );
              //         });
              //   },
              // )
            ],
          )
        : Center(
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              list[index].sender == Userinfo.userSingleton.name
                  ? 'bạn ${list[index].contentMessage} lúc ${list[index].displaytime}'
                  : '${list[index].sender} ${list[index].contentMessage} lúc ${list[index].displaytime}',
              textAlign: TextAlign.center,
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

  Widget itemImage(String name) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor),
      child: Center(
          child: Text(
        '${name.substring(0, 1)}',
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  Widget messageText(String message, String sender) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        sender.substring(sender.length - 28) != Userinfo.userSingleton.uid
            ? SizedBox(
                width: 45,
              )
            : SizedBox(
                width: 10,
              ),
        Text(
          message.substring(0, message.length - 29),
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        sender.substring(sender.length - 28) == Userinfo.userSingleton.uid
            ? SizedBox(
                width: 10,
              )
            : SizedBox(),
      ],
    );
  }
}
