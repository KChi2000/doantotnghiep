import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/Extension/DateTimeExtension.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
        element.timesent = (tri.day * 24 * 60) + (tri.hour * 60) + tri.minute;

        if (DateTime.now().weekOfMonth == tri.weekOfMonth &&
            DateTime(tri.year, tri.month, tri.day) !=
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)) {
          String day = DateFormat('EEEE').format(tri);
          switch (day) {
            case 'Monday':
              day = 'thứ 2';
              break;
            case 'Tuesday':
              day = 'thứ 3';
              break;
            case 'Wednesday':
              day = 'thứ 4';
              break;
            case 'Thursday':
              day = 'thứ 5';
              break;
            case 'Friday':
              day = 'thứ 6';
              break;
            case 'Saturday':
              day = 'thứ 7';
              break;
          }
          element.displaytime =
              '${tri.hour}:${tri.minute.toString().padLeft(2, '0')} $day';
        } else if (DateTime(tri.year, tri.month, tri.day) ==
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day)) {
          element.displaytime =
              '${tri.hour}:${tri.minute.toString().padLeft(2, '0')} hôm nay';
        } else {
          element.displaytime =
              '${tri.hour}:${tri.minute} ${tri.day}-${tri.month}-${tri.year}';
        }
        // print('time sent: ${element.time}');
      },
    );
    emit(MessageCubitState(list: rs));
  }

  void onTapMsg(int index) {
    var listtemp = state.list;
    // listtemp!.forEach((element) {
    //   element.ontap = false;
    // });
    listtemp![index].ontap = !listtemp[index].ontap;
    emit(MessageCubitState().copyWith(list: listtemp));
  }

  void unshowMsgTime() {
    var listtemp = state.list;
    listtemp!.forEach((element) {
      element.ontap = false;
    });

    emit(MessageCubitState().copyWith(list: listtemp));
  }
}
