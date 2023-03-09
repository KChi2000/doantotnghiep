import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:equatable/equatable.dart';

import '../../NetworkProvider/Networkprovider.dart';

part 'join_to_group_state.dart';

class JoinToGroupCubit extends Cubit<JoinToGroupState> {
  JoinToGroupCubit() : super(InitialGroup());
  void PassingData(String codetext) async {
    try {
      emit(LoadingGroup());
      QuerySnapshot<Object?> data = await DatabaseService().getGroups(codetext);

      GroupInfo groupdata =
          GroupInfo.fromJson(data.docs[0].data() as Map<String, dynamic>);
         
      if(groupdata.status != 'deleted'){
         print('deleted fetch from db :${groupdata.groupName}');
        emit(LoadedGroup(groupdata));
      } 
      else{
         emit(ErrorState());
      }
    } catch (e) {
      emit(ErrorState());
    }
  }

   updateData(String codetext) async {
    try {
      QuerySnapshot<Object?> data = await DatabaseService().getGroups(codetext);
      GroupInfo groupdata =
          GroupInfo.fromJson(data.docs[0].data() as Map<String, dynamic>);
      emit(LoadedGroup(groupdata));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void refreshData(int value) async {
    if (value < 6) {
      emit(ErrorState());
    }
  }

  void initData() async {
    emit(ErrorState());
  }
}
