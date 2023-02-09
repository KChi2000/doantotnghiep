import 'package:doantotnghiep/screens/chatDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../NetworkProvider/Networkprovider.dart';
import '../bloc/JoinStatus/join_status_cubit.dart';
import '../bloc/checkCode.dart/check_code_cubit.dart';
import '../bloc/joinToGroup.dart/join_to_group_cubit.dart';
import '../components/navigate.dart';
import '../constant.dart';
import '../model/Group.dart';
import '../model/UserInfo.dart';

class SearchGroup extends StatefulWidget {
  SearchGroup({super.key});
  // GroupInfo group;
  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
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
      appBar: AppBar(
        title: Text('Tìm kiếm'),
        centerTitle: false,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          //   child: BlocBuilder<CheckCodeCubit, CheckCodeState>(
          //     builder: (context, state) {
          //       return TextButton(
          //           onPressed: state.canJoined
          //               ? () {
          //                   context
          //                       .read<JoinToGroupCubit>()
          //                       .PassingData(codeCon.text);
          //                 }
          //               : null,
          //           child: Text('Tìm kiếm'));
          //     },
          //   ),
          // )
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
                              
                              Lottie.asset('assets/animations/78631-searching (1).json'),
                              Text('oops! Không tìm thấy nhóm nào cả :(('),
                              SizedBox(height: 200,)
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
                groupId: group.groupId.toString(),
                groupName: group.groupName.toString(),
                members: group.members!,
                admininfo: group.admin!,
               ));
      },
      onLongPress: () {
        print('nhả ra mau');
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
            Spacer(),
            BlocBuilder<JoindStatusCubit, JoindStatusState>(
              builder: (context, state) {
                return TextButton(
                    onPressed: () async {
                      print(group.groupId);
                      await DatabaseService(
                              uid:  Userinfo.userSingleton.uid)
                          .JoinToGroup(state.joined, group.groupId.toString(),
                              group.groupName.toString());
                      
                      context
                          .read<JoindStatusCubit>()
                          .setJoinStatus(group.groupId.toString());
                      context.read<JoinToGroupCubit>().updateData(codeCon.text);
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
