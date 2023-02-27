  import 'package:flutter/material.dart';

import '../model/User.dart';

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