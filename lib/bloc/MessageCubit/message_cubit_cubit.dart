import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/Extension/DateTimeExtension.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

part 'message_cubit_state.dart';

class MessageCubitCubit extends Cubit<MessageCubitState> {
  MessageCubitCubit() : super(MessageCubitState(list: []));
  void DisplayMessage(AsyncSnapshot<QuerySnapshot> snapshot) {
    var rs = snapshot.data!.docs
        .map((e) => Message.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    rs.forEach(
      (element) {
        var tri = DateTime.fromMicrosecondsSinceEpoch(int.parse(element.time));

        if (tri.difference(DateTime.now()).inDays == 0) {
          element.displaytime =
              '${tri.hour}:${tri.minute.toString().padLeft(2, '0')} hôm nay';
        } else if (DateTime.now().weekOfMonth == tri.weekOfMonth) {
          String day = DateFormat('EEEE').format(tri);
          switch(day){
            case 'Monday':
            element.displaytime =
              '${tri.hour}:${tri.minute.toString().padLeft(2, '0')} thứ 2';
            break;
            case 'Tuesday':
            element.displaytime =
              '${tri.hour}:${tri.minute.toString().padLeft(2, '0')} thứ 3';
            break;
            case 'Wednesday':
            element.displaytime =
              '${tri.hour}:${tri.minute.toString().padLeft(2, '0')} thứ 4';
            break;
            case 'Thursday':
            element.displaytime =
              '${tri.hour}:${tri.minute.toString().padLeft(2, '0')} thứ 5';
            break;
            case 'Friday':
            element.displaytime =
              '${tri.hour}:${tri.minute.toString().padLeft(2, '0')} thứ 6';
            break;
            case 'Saturday':
            element.displaytime =
              '${tri.hour}:${tri.minute.toString().padLeft(2, '0')} thứ 7';
            break;
          }
          
        } else {
          element.displaytime =
              '${tri.hour}:${tri.minute} ${tri.day}-${tri.month}-${tri.year}';
        }
      },
    );
    emit(MessageCubitState(list: rs));
  }

  void onTapMsg(int index) {
    var listtemp = state.list;
    listtemp!.forEach((element) {
      element.ontap = false;
    });
    listtemp[index].ontap = !listtemp[index].ontap;
    emit(MessageCubitState().copyWith(list: listtemp));
  }

  void unshowMsgTime() {}
}
