import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/JoinStatus/join_status_cubit.dart';
import 'package:doantotnghiep/bloc/checkCode.dart/check_code_cubit.dart';

import 'package:doantotnghiep/bloc/joinToGroup.dart/join_to_group_cubit.dart';
import 'package:doantotnghiep/bloc/pushNotification/push_notification_cubit.dart';

import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/model/Group.dart';

import 'package:doantotnghiep/screens/Chat/chatDetail.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../../model/User.dart';

class JoinGroup extends StatefulWidget {
  JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  var codeCon = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codeCon.clear();
    context.read<JoinToGroupCubit>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Tham gia bằng mã'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: BlocBuilder<CheckCodeCubit, CheckCodeState>(
              builder: (context, state) {
                return TextButton(
                    onPressed: state.canJoined
                        ? () {
                            context
                                .read<JoinToGroupCubit>()
                                .PassingData(codeCon.text);
                          }
                        : null,
                    child: Text('Tìm kiếm'));
              },
            ),
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: codeCon,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      isDense: true,
                      hintText: 'Nhập để tìm kiếm'),
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  onChanged: (value) {
                    context.read<CheckCodeCubit>().check(value);
                    context.read<JoinToGroupCubit>().refreshData(value.length);
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<JoinToGroupCubit, JoinToGroupState>(
                builder: (context, state) {
                  if (state is LoadedGroup) {
                    context
                        .read<JoindStatusCubit>()
                        .setJoinStatus(state.data.groupId.toString());

                    return grouprow(state.data);
                  } else if (state is LoadingGroup) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is ErrorState) {
                    return Expanded(
                      child: Center(
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
                      )),
                    );
                  }
                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Text('oops! Không tìm thấy nhóm nào cả :(('),
                        // Lottie.asset('assets/animations/78631-searching (1).json'),

                        // SizedBox(height: 200,)
                      ],
                    ),
                  );
                },
              ),
            ],
          )),
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
                    text: group.admin!.adminId.toString() ==
                            Userinfo.userSingleton.uid
                        ? 'Người tạo nhóm: bạn'
                        : 'Người tạo nhóm: ${group.admin?.adminName}',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ])),
                Text(
                  'Thành viên: ${group.members?.length.toString()}',
                )
              ],
            ),
            Spacer(),
            BlocConsumer<JoindStatusCubit, JoindStatusState>(
              listener: (context, state) {},
              builder: (context, state) {
                return  Userinfo.userSingleton.uid == group.admin!.adminId.toString()?  SizedBox(): TextButton(
                    onPressed: () async {
                      await context.read<JoindStatusCubit>().joinGroup(
                          group.groupId.toString(), group.groupName.toString());

                      await context
                          .read<JoinToGroupCubit>()
                          .updateData(codeCon.text);
                      if (state.joined) {
                       
                        Fluttertoast.showToast(
                            msg: "Đã rời nhóm thành công",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            backgroundColor: Colors.pink,
                            fontSize: 16.0);
                      } else {
                        await context.read<PushNotificationCubit>().pushNoti(group, '${Userinfo.userSingleton.name} đã tham gia nhóm');
                        Fluttertoast.showToast(
                            msg: "Đã tham gia thành công",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            backgroundColor: Colors.pink,
                            fontSize: 16.0);
                      }
                    },
                    child: state.joined
                        ? Text(
                         'Rời nhóm',
                            style: TextStyle(color: Colors.grey[400]),
                          )
                        : Text('Tham gia'));
              },
            )
          ],
        ),
      ),
    );
  }
}
