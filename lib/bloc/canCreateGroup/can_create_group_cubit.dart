import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'can_create_group_state.dart';

class CanCreateGroupCubit extends Cubit<CanCreateGroupState> {
  CanCreateGroupCubit() : super(CanCreateGroupState(canCreate: false));
  toggleTrue(){
    emit(CanCreateGroupState(canCreate: true));
  }
  toggleFalse(){
    emit(CanCreateGroupState(canCreate: false));
  }
}
