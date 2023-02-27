  import 'package:flutter/material.dart';

import '../model/Group.dart';
import '../model/User.dart';

Widget ItemThanhVien(Members e, int index,String adminid,int tongmember) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       adminid == e.Id
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
        index != tongmember - 1
            ? Divider(
                color: Colors.grey.withOpacity(0.5),
              )
            : SizedBox(),
      ],
    );
  }