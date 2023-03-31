import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/User.dart';

part 'join_status_state.dart';

class JoindStatusCubit extends Cubit<JoinState> {
  JoindStatusCubit() : super(JoindStatusState(joined: false));
  void setJoinStatus(String groupId) async {
    emit(Processing());
    var joined =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .checkIfJoined(groupId);

    emit(JoindStatusState(joined: joined));
  }

  joinGroup(String groupId, String groupName) async {
   if(state is JoindStatusState){
    var stat = (state as JoindStatusState).joined;
       String content = '';
       emit(Processing());
    await DatabaseService(uid: Userinfo.userSingleton.uid)
        .JoinToGroup(stat, groupId, groupName.toString());
    if (stat) {
      content = 'đã rời nhóm';
    } else {
      content = 'đã tham gia nhóm';
    }
     await DatabaseService().sendMessage(
        groupId,
        Message(
                sender: '${Userinfo.userSingleton.name}',
                contentMessage: content,
                time: DateTime.now().microsecondsSinceEpoch.toString(),
                type: Type.announce)
            .toMap());
    var joined =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .checkIfJoined(groupId);

    emit(JoindStatusState(joined: joined));
   }
   
  }

  leaveGroup(String groupId, String groupName) async {
    await DatabaseService(uid: Userinfo.userSingleton.uid)
        .JoinToGroup(true, groupId, groupName.toString());
         await DatabaseService().sendMessage(
        groupId,
        Message(
                sender: '${Userinfo.userSingleton.name}',
                contentMessage: 'đã rời nhóm',
                time: DateTime.now().microsecondsSinceEpoch.toString(),
                type: Type.announce)
            .toMap());
  }

  deleteGroup(String groupId, String groupname) async {
    await DatabaseService.instance.deleteGroup(groupId.toString(), groupname);
  }
}
