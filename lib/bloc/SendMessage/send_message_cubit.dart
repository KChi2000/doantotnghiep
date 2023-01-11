import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/Message.dart';
import '../../services/database_service.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit() : super(SendMessageState(isSend: false));
  sendmessage(String groupId, Message ms) async {
    try {
      emit(SendMessageState(isSend: true));
      if (ms.contentMessage.isNotEmpty &&
          ms.contentMessage.toString() != null) {
            //  DatabaseService().updateisReadMessage(groupId);
        await DatabaseService().sendMessage(groupId, ms.toMap());
       
      }
    } catch (e) {
      print('loi gui tin nhan');
    }
  }
  void initialStatusSendMessage(){
  print('chay initial status');
    emit(SendMessageState(isSend: false));
  }
}
