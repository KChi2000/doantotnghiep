import 'package:doantotnghiep/bloc/TimKiemGroup/tim_kiem_group_cubit.dart';
import 'package:doantotnghiep/screens/chatDetail.dart';
import 'package:doantotnghiep/screens/connectToFriend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';

import '../NetworkProvider/Networkprovider.dart';
import '../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../bloc/JoinStatus/join_status_cubit.dart';
import '../bloc/checkCode.dart/check_code_cubit.dart';
import '../bloc/getUserGroup/get_user_group_cubit.dart';
import '../bloc/joinToGroup.dart/join_to_group_cubit.dart';
import '../components/navigate.dart';
import '../constant.dart';
import '../model/Group.dart';
import '../model/UserInfo.dart';

class SearchGroup extends StatefulWidget {
  SearchGroup({required this.group});
  List<GroupInfo> group;
  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  var codeCon = TextEditingController();
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
      overlayWidget: Center(child: CircularProgressIndicator()),
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
                            return BlocBuilder<GroupInfoCubitCubit,
                                GroupInfoCubitState>(
                              builder: (context, state) {
                                return TextFormField(
                                  controller: codeCon,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
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
                Divider(),
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
                          return groupitem(state.filterlist[index], ct, false);
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
          ],
        ),
      ),
    );
  }
}
