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
        .map((e) => GroupInfo.fromJson(e.data() as Map<String, dynamic>))
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
    // var sort = rs;
    //  List<GroupInfo> aaa = rs.sort((a, b) => a.time!.compareTo(b.time!));
    emit(GroupInfoCubitLoaded(
        groupinfo: rs..sort((a, b) => a.time!.compareTo(b.time!)),selected: rs.first));
  }

  void chooseItemToShow(String value) {
    if (state is GroupInfoCubitLoaded) {
      var list = (state as GroupInfoCubitLoaded).groupinfo;
      int index = list!.indexWhere(
        (element) => element.groupName == value,
      );
      list.forEach((element) {
        if (element.groupId != list[index].groupId) {
          element.checked = false;
        }
      });
      list[index].checked = !list[index].checked!;
      emit(GroupInfoCubitLoading());
      emit(GroupInfoCubitLoaded().copyWith(groupinfo: list));
    }
  }

  void setFalse() {
    if (state is GroupInfoCubitLoaded) {
      var list = (state as GroupInfoCubitLoaded).groupinfo;
      list!.forEach((element) {
        element.checked = false;
      });
      emit(GroupInfoCubitLoading());
      emit(GroupInfoCubitLoaded().copyWith(groupinfo: list));
    }
  }
   void selectToShowLocation(GroupInfo select) {
   
      emit(GroupInfoCubitLoading());
      emit(GroupInfoCubitLoaded(selected: select));
       print('CLICKED ${select.groupName}');
    }
  
}
