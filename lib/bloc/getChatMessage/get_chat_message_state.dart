part of 'get_chat_message_cubit.dart';

 class GetChatMessageState extends Equatable {
  Stream? data;
  GetChatMessageState({this.data});

  @override
  List<dynamic> get props => [data];
}

