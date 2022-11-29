import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_code_state.dart';

class CheckCodeCubit extends Cubit<CheckCodeState> {
  CheckCodeCubit() : super(CheckCodeState(false));
  void check(String value) {
    if(value.length ==6){
        emit(CheckCodeState(true));
    }
    else{
      emit(CheckCodeState(false));
    }
  }
}
