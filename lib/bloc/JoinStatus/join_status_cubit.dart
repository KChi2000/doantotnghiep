import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/UserInfo.dart';

part 'join_status_state.dart';

class JoindStatusCubit extends Cubit<JoindStatusState> {
  JoindStatusCubit() : super(JoindStatusState(joined: false));
  void setJoinStatus(String groupId) async {
    var joined =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .checkIfJoined(groupId);

    emit(JoindStatusState(joined: joined));
  }

  joinGroup(String groupId, String groupName) async {
    print('state join status: ${state.joined}');
    String content = '';
    await DatabaseService(uid: Userinfo.userSingleton.uid)
        .JoinToGroup(state.joined, groupId, groupName.toString());
    if (state.joined) {
      content = 'đã rời nhóm';
    } else {
      content = 'đã tham gia nhóm';
    }
    await DatabaseService().sendMessage(
        groupId,
        Message(
                sender: '${Userinfo.userSingleton.name}',
                contentMessage: content,
                time:  DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString(),type: Type.announce)
            .toMap());
    var joined =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .checkIfJoined(groupId);

    emit(JoindStatusState(joined: joined));
  }
  leaveGroup(String groupId,String groupName)async{
     await DatabaseService(uid: Userinfo.userSingleton.uid)
        .JoinToGroup(true, groupId, groupName.toString());
  }
}
