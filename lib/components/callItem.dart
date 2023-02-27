import 'package:flutter/material.dart';

import '../model/Message.dart';
import '../model/User.dart';

Widget callItem(List<Message> list, int index) {
  return UnconstrainedBox(
    alignment: Userinfo.userSingleton.uid ==
            list[index].sender.toString().substring(
                  list[index].sender.toString().length - 28,
                )
        ? Alignment.topRight
        : Alignment.topLeft,
    child: Container(
      width: 250,
      margin: Userinfo.userSingleton.uid ==
              list[index].sender.toString().substring(
                    list[index].sender.toString().length - 28,
                  )
          ? EdgeInsets.only(right: 15,top: 10,bottom: 10)
          : EdgeInsets.only(left: 15,top: 10,bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.videocam,
                color: Color.fromARGB(255, 245, 23, 7),
              )),
          SizedBox(
            width: 10,
          ),
         list[index].contentMessage == 'Cuộc gọi video đã kết thúc' ?Flexible(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text:'${list[index].contentMessage}',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'robotobold',
                      color: Colors.black),
                ),
                TextSpan(
                  text: '\nLúc ${list[index].displaytime}',
                  style: TextStyle(
                      fontSize: 12, fontFamily: 'roboto', color: Colors.black),
                )
              ]),
            ),
          ) :Flexible(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: Userinfo.userSingleton.uid ==
            list[index].sender.toString().substring(
                  list[index].sender.toString().length - 28,
                )
                      ? 'bạn${list[index].contentMessage}'
                      : '${list[index].sender.toString().substring(0, list[index].sender.toString().length - 29)} ${list[index].contentMessage}',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'robotobold',
                      color: Colors.black),
                ),
                TextSpan(
                  text: '\nLúc ${list[index].displaytime}',
                  style: TextStyle(
                      fontSize: 12, fontFamily: 'roboto', color: Colors.black),
                )
              ]),
            ),
          ),
        ],
      ),
    ),
  );
}
