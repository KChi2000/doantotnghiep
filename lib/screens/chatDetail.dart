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

class chatDetail extends StatefulWidget {
  chatDetail({
    super.key,
    required this.groupId,
    required this.groupName,
  });
  String groupName;

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
                    return StreamBuilder<dynamic>(
                        stream: state.data,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Expanded(
                                child: Center(
                              child: CircularProgressIndicator(),
                            ));
                          }
                          print(
                              'stream data: ${snapshot.data.docs[0]['contentMessage']}');
                          return Expanded(
                            child: ListView.builder(
                              controller: listController,
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                Message message = Message(
                                    sender: snapshot.data.docs[index]['sender'],
                                    contentMessage: snapshot.data.docs[index]
                                        ['contentMessage'],
                                    time: snapshot.data.docs[index]['time']);
                              
                                return Align(
                                  alignment: Userinfo.userSingleton.uid ==
                                          message.sender.substring(
                                              message.sender.length - 28)
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        Userinfo.userSingleton.uid ==
                                                message.sender.substring(
                                                    message.sender.length - 28)
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      index >= 1 &&
                                              index <
                                                  snapshot.data.docs.length - 1
                                          ? snapshot.data.docs[index]['sender']
                                                      .toString() ==
                                                  snapshot.data
                                                      .docs[index - 1]['sender']
                                                      .toString()
                                              ? SizedBox()
                                              : messageText(message.sender,message.sender)
                                          :  messageText(message.sender,message.sender),
                                      UnconstrainedBox(
                                        child: Container(
                                          // constraints: BoxConstraints(
                                          //     maxWidth: screenwidth - 150),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Userinfo.userSingleton.uid ==
                                                    message.sender.substring(
                                                        message.sender.length -
                                                            28)
                                                ? Colors.pink
                                                : Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          margin: EdgeInsets.only(bottom: 3),
                                          child: Center(
                                              child: Text(
                                            message.contentMessage,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
                      )),
                      IconButton(
                          onPressed: () async {
                            Message ms = Message(
                                sender:
                                    '${Userinfo.userSingleton.name.toString()}_${Userinfo.userSingleton.uid.toString()}',
                                contentMessage: messageController.text,
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

  Widget messageText(String message,String sender) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
          sender.substring(sender.length-28) != Userinfo.userSingleton.uid? SizedBox(width: 10,):SizedBox(),
        Text(
          message.substring(0, message.length - 29),
          style: TextStyle(fontSize: 18, color: Colors.orange),
        ),
         sender.substring(sender.length-28) == Userinfo.userSingleton.uid? SizedBox(width: 10,):SizedBox(),
      ],
    );
  }
}
