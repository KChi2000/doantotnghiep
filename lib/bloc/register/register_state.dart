part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}
class registerLoading extends RegisterState {}
class registerLoaded extends RegisterState {}
class registerError extends RegisterState {}