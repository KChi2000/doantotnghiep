import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/bloc/getInviteId/get_invite_id_cubit.dart';

import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/UserInfo.dart';

part 'get_user_group_state.dart';

class GetUserGroupCubit extends Cubit<GetUserGroupState> {
  GetUserGroupCubit() : super(GetUserGroupState());
  void getUerGroup() async {
    Stream? userGroup = await DatabaseService(uid: Userinfo.userSingleton.uid)
        .getGroupsByUserId(Userinfo.userSingleton.name.toString());

    emit(GetUserGroupState(stream: userGroup));
  }
}
