import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class chatDetail extends StatelessWidget {
  chatDetail(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userId,
      required this.userName});
  String groupName;
  String userId;
  String userName;
  String groupId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            groupName,
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
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              
            ],
          ),
        ));
  }
}
