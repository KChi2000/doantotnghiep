import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/model/GroupInfo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'group_info_cubit_state.dart';

class GroupInfoCubitCubit extends Cubit<GroupInfoCubitState> {
  GroupInfoCubitCubit() : super(GroupInfoCubitinitial());
  void updateGroup(QuerySnapshot snapshot) {
    emit(GroupInfoCubitLoading());
    var rs = snapshot.docs
        .map((e) => GroupInfo.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    emit(GroupInfoCubitLoaded(groupinfo: rs));
  }
  void chooseItemToShow(int index){
      if(state is GroupInfoCubitLoaded){
        var list = (state as GroupInfoCubitLoaded).groupinfo;
         list!.forEach((element) { 
          element.checked=false;
     });
        bool? vl = (state as GroupInfoCubitLoaded).groupinfo![index].checked;
        list![index].checked=!vl!;
        emit(GroupInfoCubitLoading());
        emit(GroupInfoCubitLoaded().copyWith(groupinfo: list));
      
      }
  }
  void setFalse(){
     var list = (state as GroupInfoCubitLoaded).groupinfo;
     list!.forEach((element) { 
          element.checked=false;
     });
     emit(GroupInfoCubitLoading());
        emit(GroupInfoCubitLoaded().copyWith(groupinfo: list));
  }
}
