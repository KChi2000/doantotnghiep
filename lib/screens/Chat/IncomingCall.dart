import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';

import '../../bloc/toggleCM/toggle_cm_cubit.dart';
import 'CallVideo.dart';

class IncomingCall extends StatelessWidget {
  GroupInfo group;
  IncomingCall({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        width: screenwidth,
        height: screenheight,
        color: Color(0xFFFFFFFF),
        child: Column(
          children: [
            SizedBox(height: 100),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.pink,
              child: Text(
                '${group.groupName.toString().substring(0, 1)}',
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Nhóm ${group.groupName} đang gọi...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.pink, fontSize: 20),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    itemcall(
                        Icon(
                          Icons.close,
                          color: Colors.white,
                        ), () async {
                      // await signaling.hangUp(_localRenderer, widget.groupid);
                      Navigator.pop(context);
                    }, Colors.red[900]!),
                    SizedBox(height: 5),
                    Text(
                      'TỪ CHỐI',
                      style: TextStyle(fontFamily: 'robotobold'),
                    )
                  ],
                ),
                SizedBox(width: 100),
                Column(
                  children: [
                    itemcall(
                        Icon(
                          Icons.videocam,
                          color: Colors.white,
                        ),
                        () async {
                    // navigatePush(context, CallVideo(groupid: group.groupId.toString(),answere: true,));
                  
                        },
                        Colors.green),
                    SizedBox(height: 5),
                    Text(
                      'TRẢ LỜI',
                      style: TextStyle(fontFamily: 'robotobold'),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
