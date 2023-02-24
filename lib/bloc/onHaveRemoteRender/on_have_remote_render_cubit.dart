import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'on_have_remote_render_state.dart';

class OnHaveRemoteRenderCubit extends Cubit<OnHaveRemoteRenderState> {
  OnHaveRemoteRenderCubit() : super(OnHaveRemoteRenderState(addRemote: false));
  haveRemote(bool b){
    emit(OnHaveRemoteRenderState(addRemote: b));
  }

}
