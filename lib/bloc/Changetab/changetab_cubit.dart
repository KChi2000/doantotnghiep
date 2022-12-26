import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'changetab_state.dart';

class ChangetabCubit extends Cubit<ChangetabState> {
  ChangetabCubit() : super(ChangetabState(index: 0));
  void change(int pos){
    emit(ChangetabState(index: pos));
  }
}
