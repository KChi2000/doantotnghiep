import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/ChangeMessageStatus/change_message_status_cubit.dart';
import 'package:doantotnghiep/bloc/MessageCubit/message_cubit_cubit.dart';
import 'package:doantotnghiep/bloc/SendMessage/send_message_cubit.dart';
import 'package:doantotnghiep/bloc/getChatMessage/get_chat_message_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:doantotnghiep/screens/CallVideo.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/getUserGroup/get_user_group_cubit.dart';
import '../model/GroupInfo.dart';

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
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(onPressed: () {}, icon: Icon(Icons.call)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(onPressed: () {
                navigatePush(context, CallVideo());
              }, icon: Icon(Icons.videocam)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title:
                                  Text('Th??nh vi??n(${widget.members.length})'),
                              content: Container(
                                constraints: BoxConstraints(
                                    minHeight: 80, maxHeight: 200),
                                width: 100,
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
                                        'H??y nh???n g?? ???? cho c??c b???n c???a b???n n??o ((:')));
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
                          Message ms = Message(
                              sender:
                                  '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                              contentMessage: messageController.text.trim(),
                              time: DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString());
                          await context
                              .read<SendMessageCubit>()
                              .sendmessage(widget.groupId, ms);

                          messageController.clear();
                        },
                      )),
                      IconButton(
                          onPressed: () async {
                            // context.read<SendMessageCubit>().initialStatusSendMessage();
                            Message ms = Message(
                                sender:
                                    '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                                contentMessage: messageController.text.trim(),
                                time: DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString());
                            await context
                                .read<SendMessageCubit>()
                                .sendmessage(widget.groupId, ms);
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
                    '${e.Name.toString()}(B???n-Admin)',
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
        index != widget.members.length - 1 ? Divider() : SizedBox(),
      ],
    );
  }

  Column ItemMessage(List<Message> list, int index, int length) {
    return Column(
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
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'L??c ${list[index].displaytime}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )))
            : SizedBox(),
        Userinfo.userSingleton.uid ==
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
                    list[index].sender.substring(list[index].sender.length - 28)
                ? index == 0
                    ? messageText(list[index].sender, list[index].sender)
                    : list[index].sender != list[index - 1].sender
                        ? messageText(list[index].sender, list[index].sender)
                        : list[index].timesent - list[index - 1].timesent >= 4
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
                      : list[index + 1].timesent - list[index].timesent >= 4
                          ? itemImage(list[index].sender)
                          : SizedBox(
                              width: 30,
                            )
                  : index == length - 1 &&
                          Userinfo.userSingleton.uid !=
                              list[index]
                                  .sender
                                  .substring(list[index].sender.length - 28)
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        //                 return messagestatus('???? g???i', index, length);
        //               }
        //               return messagestatus('???? xem', index, length);
        //             },
        //           );
        //         });
        //   },
        // )
      ],
    );
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
