import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:doantotnghiep/model/User.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../model/Message.dart';
import '../../NetworkProvider/Networkprovider.dart';
import 'package:http/http.dart' as http;
part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit() : super(SendMessageState(isSend: false));
  sendmessage(GroupInfo group, Message ms) async {
     
    try {
        print('MESSAGE CONTENT : ${group.groupId}');
    List<Userinfo> listlocation =
        await DatabaseService().fetchGrouplocation(group);
   var token='';
   List<String?> listOfRegistration_ids =[];
      if(group.members!.length>1){
        listOfRegistration_ids =
        listlocation.map((e) => e.registrationId).toList();
      token = (await FirebaseMessaging.instance.getToken())!;
        listOfRegistration_ids.remove(token);
      }
      
     // print(
     //     'AFTER REMOVE DEVICE ID: ${listOfRegistration_ids.length}\n ${listOfRegistration_ids.first}');
      emit(SendMessageState(isSend: true));
      if (ms.contentMessage.isNotEmpty &&
          ms.contentMessage.toString() != null) {
        //  DatabaseService().updateisReadMessage(groupId)
        print('MESSAGE FROM SEND: ${ms.toMap()}');
        await DatabaseService()
            .sendMessage(group.groupId.toString(), ms.toMap());
        if(group.members!.length>1){
          http.Response response =
            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: {
                  'Authorization':
                      'key=AAAAUU2PhnA:APA91bGHF5XySlMdvuH_D8vzi0WbRxtA7bFUk-xp2Wu2MKiDEtQ7tu7gUCZS9CIAcEjJdhhTezgUPg4q6QzoABH-yDDqQfizZ5dWJVvOVQhUkV98I9afP6FPMOxa1m3fNUa7XRzS6CpZ',
                  'Content-Type': 'application/json'
                },
                body: jsonEncode(<String, dynamic>{
                  "registration_ids": listOfRegistration_ids,
                  "notification": {
                    "body":
                        "${Userinfo.userSingleton.name}: ${ms.contentMessage}",
                    "title": "${group.groupName.toString()}",
                  },
                  'android': {
                    'notification': {
                      'imageUrl': 'https://foo.bar.pizza-monster.png'
                    }
                  },
                  'priority': 'high',
                  "data": {
                    "group": "${group.toMap()}",
                    // "body": "Notification Body",
                    // "title": "title data",
                    // "key_1": "key_1 data",
                    // "key_2": "key_2 data"
                  }
                }));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void initialStatusSendMessage() {
    emit(SendMessageState(isSend: false));
  }
}
