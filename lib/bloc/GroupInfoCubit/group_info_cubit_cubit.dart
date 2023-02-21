import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/model/Group.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/UserInfo.dart';

part 'group_info_cubit_state.dart';

class GroupInfoCubitCubit extends Cubit<GroupInfoCubitState> {
  GroupInfoCubitCubit() : super(GroupInfoCubitinitial());
  void updateGroup(QuerySnapshot snapshot) {
    emit(GroupInfoCubitLoading());
    var rs = snapshot.docs
        .map((e) {
           print('DATA FROM FIREBASE: ${e.data()}');
          return GroupInfo.fromJson(e.data() as Map<String, dynamic>);
        } )
        .toList();
       
    rs.forEach(
      (element) {
        var flag = element.isReadAr!.where((element) =>
            element.Id.toString()
                .substring(element.Id.toString().length - 28) ==
            '${Userinfo.userSingleton.uid}');
        if (flag.length != 0) {
          element.checkIsRead = flag.first.isRead;
        }
      },
    );
    if (rs.length == 0) {
      emit(GroupInfoCubitLoaded(groupinfo: [], selectedGroup: GroupInfo()));
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
