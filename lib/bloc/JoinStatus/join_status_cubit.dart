import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'join_status_state.dart';

class JoindStatusCubit extends Cubit<JoindStatusState> {
  
  JoindStatusCubit()
      : super(JoindStatusState(joined: false));
  void setJoinStatus(String groupId) async {
    var joined =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .checkIfJoined(groupId);
    print(joined);
    emit(JoindStatusState(joined: joined));
  }
}
