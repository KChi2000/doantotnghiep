import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_message_status_state.dart';

class ChangeMessageStatusCubit extends Cubit<ChangeMessageStatusState> {
  ChangeMessageStatusCubit() : super(ChangeMessageStatusInitial());
}
