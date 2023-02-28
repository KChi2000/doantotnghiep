import 'package:flutter/material.dart';

import '../model/User.dart';

Widget itemImage(String name, List<Userinfo> lisUser, context) {
  return filterProfileImage(lisUser, name).isNotEmpty
      ? CircleAvatar(
        radius: 15,
          backgroundImage: Image.network(
            '${filterProfileImage(lisUser, name)}',
            fit: BoxFit.contain,
          ).image,
        )
      : Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor),
          child:  Center(
                  child: Text(
                  '${name.substring(0, 1)}',
                  style: TextStyle(color: Colors.white),
                )));
}

String filterProfileImage(List<Userinfo> list, String value) {
  String profileImage = '';
  for (Userinfo element in list) {
    print('IMAGE URL HAS FOUND : ${value.substring(value.length - 28)}');
    if (element.uid == value.substring(value.length - 28)) {
      print('IMAGE URL HAS FOUND : ${element.profilePic}');
      return element.profilePic.toString();
    }
  }
  ;
  return profileImage;
}
