import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'show_box_invite_id_state.dart';

class ShowBoxInviteIdCubit extends Cubit<ShowBoxInviteIdState> {
  ShowBoxInviteIdCubit() : super(ShowBoxInviteIdState(show: false));
  void set(bool vl){
    emit(ShowBoxInviteIdState(show: vl));
  }
}
