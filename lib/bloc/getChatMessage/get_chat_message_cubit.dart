import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:equatable/equatable.dart';

part 'get_chat_message_state.dart';

class GetChatMessageCubit extends Cubit<GetChatMessageState> {
  GetChatMessageCubit() : super(GetChatMessageState());
  void fetchData(String grId){
  Stream<QuerySnapshot<Map<String, dynamic>>> result= DatabaseService().fetchMessage(grId);
  emit(GetChatMessageState(data: result));
  }
}
