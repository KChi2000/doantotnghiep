import 'package:doantotnghiep/components/navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../constant.dart';
import '../model/Group.dart';
import '../model/UserInfo.dart';
import '../screens/chatDetail.dart';

class MessageRow extends StatelessWidget {
   MessageRow(this.group,this.ind);
GroupInfo group;
 String ind;
  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap: () {
        context.read<GroupInfoCubitCubit>().setFalse();
        navigatePush(
            context,
            chatDetail(
              groupId: group.groupId.toString(),
              groupName: group.groupName.toString(),
              members: group.members!,
              admininfo: group.admin!,
            ));
      },
      onLongPress: () {},
      child: Stack(
        children: [
          Container(
            width: screenwidth,
            // height: 55,
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 10,top: 10),
            
            decoration: BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                CircleAvatar(
                  minRadius: 30,
                  child: Container(
                    child: Center(
                      child: Text(group.groupName.toString().substring(0, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  // width: screenwidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.groupName.toString(),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontWeight: group.checkIsRead!
                                ? FontWeight.w400
                                : FontWeight.w600),
                      ),
                      Row(mainAxisSize: MainAxisSize.max, children: [
                        Text(
                          group.recentMessageSender != null &&
                                  group.recentMessageSender
                                      .toString()
                                      .isNotEmpty
                              ? Userinfo.userSingleton.uid ==
                                      group.recentMessageSender
                                          .toString()
                                          .substring(group.recentMessageSender
                                                  .toString()
                                                  .length -
                                              28)
                                  ? 'Bạn:'
                                  : '${group.recentMessageSender.toString().substring(0, group.recentMessageSender.toString().length - 29)}:'
                              : 'Chưa có tin nhắn nào',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: group.checkIsRead!
                                  ? FontWeight.w400
                                  : FontWeight.w600),
                        ),
                        Flexible(
                          // width: 200,
                          child: Text(
                            group.recentMessage != null
                                ? ' ${group.recentMessage.toString()}'
                                : '',
                            maxLines: 1,
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: group.checkIsRead!
                                    ? FontWeight.w400
                                    : FontWeight.w600),
                          ),
                        ),
                        Text('  '),
                        Text(
                          group.time == null || group.time.toString().isEmpty
                              ? ''
                              : '${DateTime.fromMicrosecondsSinceEpoch(int.parse(group.time!)).toString().split(' ').last.substring(0, 5)}',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: group.checkIsRead!
                                  ? FontWeight.w400
                                  : FontWeight.w600),
                        )
                      ])
                    ],
                  ),
                ),
                // Spacer(),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          context
                              .read<GroupInfoCubitCubit>()
                              .chooseItemToShow(ind);
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black54,
                        )))
              ],
            ),
          ),
          group.checked!
              ? Positioned(
                  right: 50,
                  top: 20,
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: group.inviteId))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Invite id copied to clipboard: ${group.inviteId}"),
                          duration: Duration(seconds: 2),
                        ));
                      });
                      context.read<GroupInfoCubitCubit>().setFalse();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 0.1,
                                color: Colors.grey.withOpacity(0.2))
                          ]),
                      child: Text('Copy invite id'),
                    ),
                  ))
              : SizedBox()
        ],
      ),
    );
  }
}