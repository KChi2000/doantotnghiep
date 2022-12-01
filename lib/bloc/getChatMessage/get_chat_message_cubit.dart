import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:equatable/equatable.dart';

part 'get_chat_message_state.dart';

class GetChatMessageCubit extends Cubit<GetChatMessageState> {
  GetChatMessageCubit() : super(GetChatMessageState());
  void fetchData(String grId){
  var result= DatabaseService().fetchMessage(grId);
  emit(GetChatMessageState(data: result));
  }
}
