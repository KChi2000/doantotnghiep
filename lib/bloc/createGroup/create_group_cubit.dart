import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../NetworkProvider/Networkprovider.dart';
import '../../model/User.dart';

part 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  CreateGroupCubit() : super(CreateGroupState(inviteid: ''));
  creategroup(String groupname)async{
   
   await DatabaseService(
                        uid: Userinfo.userSingleton.uid,
                      ).CreateGroup(
                          groupname,
                          Userinfo.userSingleton.uid!,
                          Userinfo.userSingleton.name!,state.inviteid);
    
  }
  createInviteId(){
     Random _rnd = Random();

  var _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
   
  
    emit(CreateGroupState(inviteid: getRandomString(6)));
  }
}
