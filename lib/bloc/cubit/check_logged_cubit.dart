import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'check_logged_state.dart';

class CheckLoggedCubit extends Cubit<CheckLoggedState> {
  CheckLoggedCubit() : super(CheckLoggedState(''));
}
