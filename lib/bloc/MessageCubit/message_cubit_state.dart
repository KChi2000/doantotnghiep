// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'message_cubit_cubit.dart';

class MessageCubitState extends Equatable {
  List<Message>? list;
   MessageCubitState({ this.list});

  @override
  List<Object> get props => [list!,identityHashCode(this)];

  MessageCubitState copyWith({
    List<Message>? list,
  }) {
    return MessageCubitState(
      list: list ?? this.list,
    );
  }
}

// class MessageCubitInitial extends MessageCubitState {}
