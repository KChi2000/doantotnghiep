import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/Message.dart';
import '../../services/database_service.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit() : super(SendMessageInitial());
   sendmessage(String groupId, Message ms) async {
   try{
     emit(SendMessageFlag());
    if(ms.contentMessage.isNotEmpty && ms.contentMessage.toString() !=null){
       await DatabaseService().sendMessage(groupId, ms.toMap());
    // emit(SendMessageComplete('dsad'));
    // print(' gui tin nhan');
    }
   }catch(e){
    print('loi gui tin nhan');
   }
  }
}
