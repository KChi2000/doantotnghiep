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
       print('day ${DateFormat('EEEE').format(tri)}');
        if (tri.difference(DateTime.now()).inDays == 0) {
          print('phut ${tri.minute}');
          element.displaytime = '${tri.hour}:${tri.minute.toString().padLeft(2,'0')} hôm nay';
        } 
        else if(DateTime.now().weekOfMonth == tri.weekOfMonth){
            String day=  DateFormat('EEEE').format(tri); 
            
            element.displaytime = '${tri.hour}:${tri.minute.toString().padLeft(2,'0')} $day';
        }
        else {
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
