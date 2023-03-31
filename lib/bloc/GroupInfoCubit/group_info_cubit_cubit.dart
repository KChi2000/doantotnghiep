import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/bloc/countToBuild/count_to_build_cubit.dart';
import 'package:doantotnghiep/model/Group.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/User.dart';

part 'group_info_cubit_state.dart';

class GroupInfoCubitCubit extends Cubit<GroupInfoCubitState> {
  GroupInfoCubitCubit() : super(GroupInfoCubitinitial());
  void updateGroup(QuerySnapshot snapshot) {
    List<GroupInfo>? saved = [];
    if (state is GroupInfoCubitLoaded) {
      saved = (state as GroupInfoCubitLoaded).groupinfo!;
      saved..sort((a, b) => a.time!.compareTo(b.time!));
      var filter = saved.where((element) =>
          element.groupId ==
          (state as GroupInfoCubitLoaded).selectedGroup!.groupId);
      if (filter.length != 0) {
        print('SAVE IN BLOC ${filter.first.members!.length}');
      }
    }
    emit(GroupInfoCubitLoading());
    var rs = snapshot.docs.map((e) {
      return GroupInfo.fromJson(e.data() as Map<String, dynamic>);
    }).toList();

    rs.forEach(
      (element) async {
        if (element.status == 'deleted') {
          var timeDeleted = DateTime.fromMicrosecondsSinceEpoch(
              int.parse(element.time.toString()));
          // element.time = DateTime.fromMicrosecondsSinceEpoch(
          //     int.parse(element.time.toString()));
          if (timeDeleted.compareTo(DateTime.now()) <= 0) {
            await DatabaseService().deleteDataInFB(
                element.groupId.toString(), element.groupName.toString());
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
      emit(GroupInfoCubitLoaded(
        groupinfo: [],
        selectedGroup: GroupInfo(),
        savedGroupinfo: [],
      ));
    } else if (rs.length == 1) {
      emit(GroupInfoCubitLoaded(
        groupinfo: rs,
        selectedGroup: rs.first,
        savedGroupinfo: saved,
      ));
    } else {
      emit(GroupInfoCubitLoaded(
        groupinfo: rs
          ..sort((a, b) {
            if (a.status == 'deleted') {
              a.time = DateTime.fromMicrosecondsSinceEpoch(int.parse(a.time!))
                  .subtract(Duration(minutes: 5))
                  .microsecondsSinceEpoch
                  .toString();
            } else if (b.status == 'deleted') {
              b.time = DateTime.fromMicrosecondsSinceEpoch(int.parse(b.time!))
                  .subtract(Duration(minutes: 5))
                  .microsecondsSinceEpoch
                  .toString();
            }
            return a.time!.compareTo(b.time!);
          }),
        selectedGroup: rs.last,
        savedGroupinfo: saved,
      ));
    }
  }

  changeSelectedGroup(GroupInfo group) {
    // emit(GroupInfoCubitLoading());
    print('BEFORE UPDATE SELECTED GROUP STATE IS $state');
    if (state is GroupInfoCubitLoaded) {
      emit(GroupInfoCubitLoaded(
          groupinfo: (state as GroupInfoCubitLoaded).groupinfo,
          savedGroupinfo: (state as GroupInfoCubitLoaded).savedGroupinfo,
          selectedGroup: group));
    }
  }

  initial() {
    emit(GroupInfoCubitinitial());
  }
}
