import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/MessageCubit/message_cubit_cubit.dart';
import 'package:doantotnghiep/bloc/getChatMessage/get_chat_message_cubit.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _chatDetailState extends State<chatDetail> {
  var listController = ScrollController();
  var messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetChatMessageCubit>().fetchData(widget.groupId);
  }

  void InitialpositionList() {
    setState(() {
      listController.animateTo(listController.position.maxScrollExtent,
          duration: Duration(microseconds: 100), curve: Curves.linear);
    });
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
              child: IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title:
                                  Text('Thành viên(${widget.members.length})'),
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
                          context
                              .read<MessageCubitCubit>()
                              .DisplayMessage(snapshot);
                          return BlocConsumer<MessageCubitCubit,
                              MessageCubitState>(
                            listener: (context, state) {
                              print('cubit change');
                            },
                            builder: (context, state) {
                              return Expanded(
                                child: ListView.builder(
                                  controller: listController,
                                  shrinkWrap: true,
                                  itemCount: state.list!.length,
                                  itemBuilder: (context, index) {
                                    return ItemMessage(state.list![index],
                                        index, state.list!.length);
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
                        onTap: () {
                          InitialpositionList();
                        },
                        onFieldSubmitted: (value) async {
                          Message ms = Message(
                              sender:
                                  '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                              contentMessage: messageController.text.trim(),
                              time: DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString());
                          await DatabaseService()
                              .sendMessage(widget.groupId, ms.toMap());
                          messageController.clear();
                        },
                      )),
                      IconButton(
                          onPressed: () async {
                            Message ms = Message(
                                sender:
                                    '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                                contentMessage: messageController.text.trim(),
                                time: DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString());
                            await DatabaseService()
                                .sendMessage(widget.groupId, ms.toMap());
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
            ? Userinfo.userSingleton.uid == e.Id?Text(
                '${e.Name.toString()}(Bạn-Admin)',
                style: TextStyle(fontSize: 18),
              )
            :Text(
                '${e.Name.toString()}(Admin)',
                style: TextStyle(fontSize: 18),
              )
            : Text(
                '${e.Name.toString()}',
                style: TextStyle(fontSize: 18),
              ),
               index != widget.members.length-1 ? Divider() : SizedBox(),
      ],
    );
  }

  Column ItemMessage(Message msg, int index, int length) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: Userinfo.userSingleton.uid ==
              msg.sender.substring(msg.sender.length - 28)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        msg.ontap
            ? Center(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'Lúc ${msg.displaytime}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )))
            : SizedBox(),
        GestureDetector(
          onTap: () {
            context.read<MessageCubitCubit>().onTapMsg(index);
            print('ontappppppp');
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenwidth - 150,
              // minWidth: 50
            ),
            // width: screenwidth - 150,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Userinfo.userSingleton.uid ==
                      msg.sender.substring(msg.sender.length - 28)
                  ? Colors.pink
                  : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(bottom: 3),
            child: Text(
              msg.contentMessage,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        index < length - 1
            ? msg.sender.toString() == msg.sender.toString()
                ? SizedBox()
                : messageText(msg.sender, msg.sender)
            : messageText(msg.sender, msg.sender),
      ],
    );
  }

  Widget messageText(String message, String sender) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        sender.substring(sender.length - 28) != Userinfo.userSingleton.uid
            ? SizedBox(
                width: 10,
              )
            : SizedBox(),
        Text(
          message.substring(0, message.length - 29),
          style: TextStyle(fontSize: 16, color: Colors.black54),
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
