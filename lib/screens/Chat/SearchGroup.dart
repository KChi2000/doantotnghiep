import 'package:doantotnghiep/bloc/TimKiemGroup/tim_kiem_group_cubit.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:doantotnghiep/screens/Chat/chatDetail.dart';
import 'package:doantotnghiep/screens/Chat/connectToFriend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';

import '../../NetworkProvider/Networkprovider.dart';
import '../../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../../bloc/JoinStatus/join_status_cubit.dart';
import '../../bloc/checkCode.dart/check_code_cubit.dart';
import '../../bloc/getUserGroup/get_user_group_cubit.dart';
import '../../bloc/joinToGroup.dart/join_to_group_cubit.dart';
import '../../components/navigate.dart';
import '../../constant.dart';
import '../../model/Group.dart';
import '../../model/User.dart';

class SearchGroup extends StatefulWidget {
  SearchGroup({required this.group});
  List<GroupInfo> group;
  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  var codeCon = TextEditingController();
  var myFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TimKiemGroupCubit>().resetfilterlist();
  }

  @override
  Widget build(BuildContext ct) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.6,
      overlayWidget: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          // Text(
          //   'Đang rời nhóm...',
          //   style: TextStyle(color: Colors.white),
          // )
        ],
      )),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Tìm kiếm'),
          centerTitle: false,
          actions: [],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: BlocBuilder<GetUserGroupCubit, GetUserGroupState>(
                    builder: (context, state) {
                      return StreamBuilder(
                          stream: state.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              context
                                  .read<GroupInfoCubitCubit>()
                                  .updateGroup(snapshot.data);
                            }
                            return BlocConsumer<GroupInfoCubitCubit,
                                GroupInfoCubitState>(
                              listener: (context, state) {
                                if (state is GroupInfoCubitLoaded) {
                                  context
                                      .read<TimKiemGroupCubit>()
                                      .TimKiem(state.groupinfo!, codeCon.text);
                                }
                              },
                              builder: (context, state) {
                                return TextFormField(
                                  focusNode: myFocusNode,
                                  controller: codeCon,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      isDense: true,
                                      hintText: 'Nhập để tìm kiếm'),
                                  onChanged: (value) {
                                    context.read<TimKiemGroupCubit>().TimKiem(
                                        (state as GroupInfoCubitLoaded)
                                            .groupinfo!,
                                        value);
                                  },
                                );
                              },
                            );
                          });
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 15,
                ),
                BlocBuilder<TimKiemGroupCubit, TimKiemGroupState>(
                  builder: (context, state) {
                    if (state.filterlist.length > 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.filterlist.length,
                        itemBuilder: (context, index) {
                          return groupitems(
                            state.filterlist[index],
                            ct,
                            false,
                            myFocusNode,
                          );
                        },
                      );
                    }
                    return Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Lottie.asset(
                              'assets/animations/78631-searching (1).json'),
                          Text('oops! Không tìm thấy nhóm nào cả :(('),
                          SizedBox(
                            height: 200,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget grouprow(GroupInfo group) {
    return GestureDetector(
      onTap: () {
        navigatePush(
            context,
            chatDetail(
             group: group,
            ));
      },
    
      child: Container(
        // margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        color: Colors.transparent,
        width: screenwidth,
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
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.groupName.toString(),
                  style: TextStyle(color: Colors.black87, fontSize: 17),
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'Người tạo nhóm: ${group.admin?.adminName}',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ])),
                Text(
                  'Thành viên: ${group.members?.length.toString()}',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget groupitems(
    GroupInfo group, BuildContext ct, bool margin, FocusNode focusNode) {
  return GestureDetector(
    onTap: group.status == 'deleted'
          ? null
          : () {
      navigateReplacement(
          ct,
          chatDetail(
          group: group,
          ));
    },
    onLongPress: () {},
    child: Stack(
      children: [
        Container(
          width: screenwidth,
          height: 55,
          margin: margin
              ? EdgeInsets.only(left: 10, right: 10, bottom: 10)
              : EdgeInsets.only(bottom: 10),
          color: Colors.transparent,
          child: Row(
            children: [
              CircleAvatar(
                minRadius: 30,
                child: Container(
                  child: Center(
                    child: Text(
                      group.groupName.toString().substring(0, 1),
                      style: TextStyle(color: Colors.white),
                    ),
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
                          color:group.status == 'deleted'
                          ? Colors.grey: Colors.black87,
                          fontSize: 17,
                          fontWeight: group.status == 'deleted'
                          ?  FontWeight.normal: group.checkIsRead!
                              ? FontWeight.w400
                              : FontWeight.w600),
                    ),
                    group.status == 'deleted'
                          ? Text(
                              Userinfo.userSingleton.uid ==
                                      group.admin!.adminId.toString()
                                  ? 'Nhóm đã bị xóa bởi bạn'
                                  : 'Nhóm đã bị xóa bởi Admin',
                              style: TextStyle(color: Colors.grey),
                            )
                          :  Row(mainAxisSize: MainAxisSize.max, children: [
                      group.type == Type.announce
                          ? SizedBox()
                          : Text(
                              group.type != Type.announce
                                  ? Userinfo.userSingleton.uid ==
                                          group.recentMessageSender
                                              .toString()
                                              .substring(group
                                                      .recentMessageSender
                                                      .toString()
                                                      .length -
                                                  28)
                                      ? 'Bạn: '
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
                        child: group.type == Type.announce
                            ? Text(
                                group.recentMessageSender ==
                                        Userinfo.userSingleton.name
                                    ? 'bạn ${group.recentMessage.toString()}'
                                    : group.recentMessageSender
                                                .toString()
                                                .isEmpty ||
                                            group.recentMessageSender == null
                                        ? '${group.recentMessage.toString()}'
                                        : '${group.recentMessageSender} ${group.recentMessage.toString()}',
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: group.checkIsRead!
                                        ? FontWeight.w400
                                        : FontWeight.w600),
                              )
                            : Text(
                                group.recentMessage != null
                                    ? '${group.recentMessage.toString()}'
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
                      group.recentMessageSender.toString().isEmpty ||
                              group.recentMessageSender == null
                          ? SizedBox()
                          : Text(
                              group.time == null ||
                                      group.time.toString().isEmpty
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
            group.status == 'deleted'
                    ? SizedBox()
                    :  Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                      offset: Offset(-30, 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 10,
                      padding: EdgeInsets.all(0),
                      surfaceTintColor: Colors.white,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            onTap: () {
                              FocusScope.of(ct).requestFocus(FocusNode());
                              Clipboard.setData(
                                      ClipboardData(text: group.inviteId))
                                  .then((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Invite id copied to clipboard: ${group.inviteId}"),
                                  duration: Duration(seconds: 2),
                                ));
                              });
                            },
                            child: Text(
                              'Copy inviteid',
                              style: TextStyle(color: Colors.pink),
                            ),
                            padding:
                                EdgeInsets.only(top: 5, bottom: 5, left: 10),
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'roboto'),
                          ),
                               PopupMenuItem(
                                  onTap: () async {
                                    if (Userinfo.userSingleton.uid !=
                                        group.admin!.adminId.toString()) {
                                      Future.delayed(
                                        const Duration(seconds: 0),
                                        () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            title: Text(
                                                'Bạn có chắc muốn rời nhóm?'),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Hủy')),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    ct.loaderOverlay.show();
                                                    await context
                                                        .read<
                                                            JoindStatusCubit>()
                                                        .leaveGroup(
                                                            group.groupId
                                                                .toString(),
                                                            group.groupName
                                                                .toString());
                                                    ct.loaderOverlay.hide();
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Đã rời nhóm thành công",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.white,
                                                        backgroundColor:
                                                            Colors.pink,
                                                        fontSize: 16.0);
                                                  },
                                                  child: Text('Xác nhận'))
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      Future.delayed(
                                        const Duration(seconds: 0),
                                        () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            title: Text(
                                                'Bạn có chắc muốn xóa nhóm?'),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Hủy')),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    ct.loaderOverlay.show();
                                                    await context
                                                        .read<
                                                            JoindStatusCubit>()
                                                        .deleteGroup(
                                                            group.groupId
                                                                .toString(),
                                                            group.groupName
                                                                .toString());
                                                    ct.loaderOverlay.hide();
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Đã xóa thành công",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.white,
                                                        backgroundColor:
                                                            Colors.pink,
                                                        fontSize: 16.0);
                                                  },
                                                  child: Text('Xác nhận'))
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                      Userinfo.userSingleton.uid ==
                                              group.admin!.adminId.toString()
                                          ? 'Xoá nhóm'
                                          : 'Rời nhóm',
                                      style: TextStyle(color: Colors.pink)),
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10),
                                  // height: 20,
                                  textStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                )
                        ];
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black54,
                      )))
            ],
          ),
        ),
      ],
    ),
  );
}
