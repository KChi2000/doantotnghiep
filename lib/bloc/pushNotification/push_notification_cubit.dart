import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../../NetworkProvider/Networkprovider.dart';
import '../../model/User.dart';
part 'push_notification_state.dart';

class PushNotificationCubit extends Cubit<PushNotificationState> {
  PushNotificationCubit() : super(PushNotificationInitial());
  pushNoti(GroupInfo group,String content)async{
     List<Userinfo> listlocation =
        await DatabaseService().fetchGrouplocation(group);
    List<String?> listOfRegistration_ids =
        listlocation.map((e) => e.registrationId).toList();
    try{
     var token = await FirebaseMessaging.instance.getToken();
      listOfRegistration_ids.remove(token);
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
                        "${content}",
                    "title": "${group.groupName.toString()}"
                  },
                  'priority': 'high',
                  "data": {}
                }));
    }catch(e){

    }
  }
   pushCallNoti(GroupInfo group,String content,Map<String,dynamic> data)async{
     List<Userinfo> listlocation =
        await DatabaseService().fetchGrouplocation(group);
    List<String?> listOfRegistration_ids =
        listlocation.map((e) => e.registrationId).toList();
    try{
     var token = await FirebaseMessaging.instance.getToken();
    print('GROUP TO STRING: ${group.toStringS()}');
      listOfRegistration_ids.remove(token);
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
                        "${content}",
                    "title": group.toStringS()
                  },
                  'priority': 'high',
                  "data": data
                }));
    }catch(e){
        print(e.toString());
    }
  }
}
