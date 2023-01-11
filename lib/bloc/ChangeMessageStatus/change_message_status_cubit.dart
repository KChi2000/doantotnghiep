import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../model/GroupInfo.dart';

part 'change_message_status_state.dart';

class ChangeMessageStatusCubit extends Cubit<ChangeMessageStatusState> {
  ChangeMessageStatusCubit() : super(ChangeMessageStatusState(viewer: []));
  void update(QuerySnapshot snapshot,String grid){
    try{
       var data = snapshot.docs
        .map((e) => GroupInfo.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    var getcurrentgroup = data.where((element) => element.groupId==grid).toList();
    List<Read>? getliststatus = getcurrentgroup.first.isReadAr;
    var filterlist = getliststatus!.where((element) => element.isRead==true).toList();
    print('filter list is read ${filterlist.length}');
    emit(ChangeMessageStatusState(viewer: filterlist.map((element) => element.Id!.substring(element.Id!.length-28)).toList()));
    }catch(e){
      print('xxay ra loix');
    }
  }
}
