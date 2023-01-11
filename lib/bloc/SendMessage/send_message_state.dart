part of 'send_message_cubit.dart';

 class SendMessageState extends Equatable {
  bool isSend;
   SendMessageState({required this.isSend});

  @override
  List<Object> get props => [isSend];
}

// class SendMessageInitial extends SendMessageState {}
// class SendMessageFlag extends SendMessageState {}
// class SendMessageComplete extends SendMessageState {
//   String s;
//   SendMessageComplete(this.s);
//    @override
//   List<Object> get props => [s];
// }
