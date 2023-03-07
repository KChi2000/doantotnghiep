import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/model/User.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../model/Message.dart';
import '../../NetworkProvider/Networkprovider.dart';
import 'package:http/http.dart' as http;
part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit() : super(SendMessageState(isSend: false));
  sendmessage(String groupId, Message ms, String grname) async {
      List<String> listOfRegistration_ids = [
                    "foMXs52QRUWcCYDEnyogga:APA91bGJdoLGciNHC4tN5j1_Pe-dA_h4IKzZVVs5qMyLBJMsWIKgrcr_PODs0jrVp6hI9QjRCYCdHJfgjBzgWyp2zoy-M4P7RsjEjgXuWPrsJNeftiAGvPWj3LcWHLFPI4dCH-N4zhyQ",
                    "eBxMYdTxQBSR8DG32T6Oja:APA91bEv4B6-wte61qS1AWazWLd9lL1S5IYt7Nb7Tres6vxIt4Shsgtol04ciAnhsLTBTP65wJKqx3KA35dmYKPNAO9eHiEBnf_1X54v3oar6wE44tzKH9-ZlXU_J7wn_MfYN_2lZV5R"
                  ];
    try {
      var token= await FirebaseMessaging.instance.getToken();
      listOfRegistration_ids.remove(token);
      emit(SendMessageState(isSend: true));
      if (ms.contentMessage.isNotEmpty &&
          ms.contentMessage.toString() != null) {
        //  DatabaseService().updateisReadMessage(groupId);
        await DatabaseService().sendMessage(groupId, ms.toMap());
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
      }
    } catch (e) {
      print('loi gui tin nhan');
    }
  }

  void initialStatusSendMessage() {
    print('chay initial status');
    emit(SendMessageState(isSend: false));
  }
}
