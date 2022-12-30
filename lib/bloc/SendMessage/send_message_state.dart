part of 'send_message_cubit.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

class SendMessageInitial extends SendMessageState {}
class SendMessageFlag extends SendMessageState {}
class SendMessageComplete extends SendMessageState {
  String s;
  SendMessageComplete(this.s);
   @override
  List<Object> get props => [s];
}
