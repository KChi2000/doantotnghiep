import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/model/Group.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/User.dart';

part 'group_info_cubit_state.dart';

class GroupInfoCubitCubit extends Cubit<GroupInfoCubitState> {
  GroupInfoCubitCubit() : super(GroupInfoCubitinitial());
  void updateGroup(QuerySnapshot snapshot) {
    emit(GroupInfoCubitLoading());
    var rs = snapshot.docs.map((e) {
      // print('DATA FROM FIREBASE: ${e.data()}');
      return GroupInfo.fromJson(e.data() as Map<String, dynamic>);
    }).toList();

    rs.forEach(
      (element)async {
        if (element.status == 'deleted') {
          var timeDeleted = DateTime.fromMicrosecondsSinceEpoch(
              int.parse(element.time.toString()));
            print('Time deleted: $timeDeleted  time now ${DateTime.now} compare: ${timeDeleted.compareTo(DateTime.now())}');
            if(timeDeleted.compareTo(DateTime.now())<=0){
             
                await DatabaseService().deleteDataInFB(element.groupId.toString(), element.groupName.toString());
            }
        }
        var flag = element.isReadAr!.where((element) =>
            element.Id.toString()
                .substring(element.Id.toString().length - 28) ==
            '${Userinfo.userSingleton.uid}');
        if (flag.length != 0) {
          element.checkIsRead = flag.first.isRead;
        }
      },
    );
    // rs = rs.where((element) => element.status != 'deleted').toList();
    if (rs.length == 0) {
      emit(GroupInfoCubitLoaded(groupinfo: [], selectedGroup: GroupInfo()));
    } else if (rs.length == 1) {
      emit(GroupInfoCubitLoaded(groupinfo: rs, selectedGroup: rs.first));
    } else {
      emit(GroupInfoCubitLoaded(
          groupinfo: rs..sort((a, b) => a.time!.compareTo(b.time!)),
          selectedGroup: rs.last));
    }
  }

  changeSelectedGroup(GroupInfo group) {
    emit(GroupInfoCubitLoading());
    emit(GroupInfoCubitLoaded(
        groupinfo: (state as GroupInfoCubitLoaded).groupinfo,
        selectedGroup: group));
  }
}
