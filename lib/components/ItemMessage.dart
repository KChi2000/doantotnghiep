import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../bloc/MessageCubit/message_cubit_cubit.dart';
import '../constant.dart';
import '../model/Message.dart';
import '../model/User.dart';
import 'callItem.dart';
import 'itemImage.dart';
import 'messageText.dart';

class ItemMessage extends StatelessWidget {
  ItemMessage(
      {required this.list,
      this.listUser,
      required this.index,
      required this.length});
  List<Message> list;
  List<Userinfo>? listUser;
  int index;
  int length;
  @override
  Widget build(BuildContext context) {
    switch (list[index].type) {
      case Type.text:
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
                            : list[index].timesent - list[index - 1].timesent >=
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
                          ? itemImage(list[index].sender, listUser!, context)
                          : list[index + 1].timesent - list[index].timesent >= 4
                              ? itemImage(
                                  list[index].sender, listUser!, context)
                              : SizedBox(
                                  width: 30,
                                )
                      : index == length - 1 &&
                              Userinfo.userSingleton.uid !=
                                  list[index]
                                      .sender
                                      .substring(list[index].sender.length - 28)
                          ? itemImage(list[index].sender, listUser!, context)
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
          ],
        );

      case Type.announce:
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            list[index].sender.toString().length < 28
                ? list[index].sender.toString() == Userinfo.userSingleton.name?'Bạn ${list[index].contentMessage} lúc ${list[index].displaytime}' :'${list[index].sender.toString()} ${list[index].contentMessage} lúc ${list[index].displaytime}'
                : Userinfo.userSingleton.uid ==
                        list[index].sender.toString().substring(
                              list[index].sender.toString().length - 28,
                            )
                    ? 'Bạn ${list[index].contentMessage} lúc ${list[index].displaytime}'
                    : '${list[index].sender.toString().substring(
                          0,
                          list[index].sender.toString().length - 29,
                        )} ${list[index].contentMessage} lúc ${list[index].displaytime}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ));

      case Type.callvideo:
        return callItem(list, listUser!, index, Icons.videocam, context);
      case Type.callaudio:
        return callItem(list, listUser!, index, Icons.call, context);

      default:
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
                            : list[index].timesent - list[index - 1].timesent >=
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
                          ? itemImage(list[index].sender, listUser!, context)
                          : list[index + 1].timesent - list[index].timesent >= 4
                              ? itemImage(
                                  list[index].sender, listUser!, context)
                              : SizedBox(
                                  width: 30,
                                )
                      : index == length - 1 &&
                              Userinfo.userSingleton.uid !=
                                  list[index]
                                      .sender
                                      .substring(list[index].sender.length - 28)
                          ? itemImage(list[index].sender, listUser!, context)
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
          ],
        );
    }
  }
}
