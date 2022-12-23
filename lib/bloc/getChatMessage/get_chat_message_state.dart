part of 'get_chat_message_cubit.dart';

 class GetChatMessageState extends Equatable {
  Stream<QuerySnapshot<Map<String, dynamic>>>? data;
  GetChatMessageState({ this.data});

  @override
  List<dynamic> get props => [data];
}

