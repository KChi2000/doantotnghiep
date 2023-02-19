part of 'reset_email_cubit.dart';

abstract class ResetEmailState extends Equatable {
  const ResetEmailState();

  @override
  List<Object> get props => [];
}

class ResetEmailInitial extends ResetEmailState {}

class ResetEmailLoading extends ResetEmailState {}

class ResetEmailLoaded extends ResetEmailState {}

class ResetEmailError extends ResetEmailState {
  String error;
  ResetEmailError(this.error);
  @override
  List<Object> get props => [error];
}
