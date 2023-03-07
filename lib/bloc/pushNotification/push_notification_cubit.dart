import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../../model/User.dart';
part 'push_notification_state.dart';

class PushNotificationCubit extends Cubit<PushNotificationState> {
  PushNotificationCubit() : super(PushNotificationInitial());
  pushNoti(String grname,String content)async{
    List<String> listOfRegistration_ids = [
                    "c703z063S36jDx-OsYfh6H:APA91bFU0j1v9phGcmHe6zn05Q-9bsG8qK2HVO72JPnsNNJttZuRvQJeVVfmGBYBPA7ACi8C2NvLetpQqexe1WXkHOoKgXsOIkFDv2myr6PoDGqU1fEyraKN1gkmGCoZ0Qr7BgBqxXCf",
                    "cWOiHtD1RIS9STK1pgISto:APA91bFSORzkRpBxJlijPVme5GnakAdZXQOOeVrZWzBaY-vI_S8lsWPPjXv1cVB5hXjGsLgFYvbVEigGls7DsvbpJ2TVk7WrjTZ_52ctX6zYVWPs9c8yLQiwYP6rqEvH4FxCBc9lRvmw"
                  ];
    try{
     var token= await FirebaseMessaging.instance.getToken();
       http.Response response =
            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: {
                  'Authorization':
                      'key=AAAAUU2PhnA:APA91bGHF5XySlMdvuH_D8vzi0WbRxtA7bFUk-xp2Wu2MKiDEtQ7tu7gUCZS9CIAcEjJdhhTezgUPg4q6QzoABH-yDDqQfizZ5dWJVvOVQhUkV98I9afP6FPMOxa1m3fNUa7XRzS6CpZ',
                  'Content-Type': 'application/json'
                },
                body: jsonEncode(<String, dynamic>{
                  "registration_ids": listOfRegistration_ids.remove(token),
                  "notification": {
                    "body":
                        "${content}",
                    "title": "${grname}"
                  },
                  'priority': 'high',
                  "data": {
                    "body": "Notification Body",
                    "title": "Notification Title",
                    "key_1": "Value for key_1",
                    "key_2": "Value for key_2"
                  }
                }));
    }catch(e){

    }
  }
}
