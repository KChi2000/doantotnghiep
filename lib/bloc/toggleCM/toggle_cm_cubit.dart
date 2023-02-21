import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'toggle_cm_state.dart';

class ToggleCmCubit extends Cubit<ToggleCmState> {
  ToggleCmCubit()
      : super(ToggleCmState(
            openCamera: true, enableMic: true, useFrontCamera: true));
  toggleCamera() {
    emit(ToggleCmState(
        openCamera: !state.openCamera,
        enableMic: state.enableMic,
        useFrontCamera: state.useFrontCamera));
  }

  toggleMic() {
    emit(ToggleCmState(
        openCamera: state.openCamera,
        enableMic: !state.enableMic,
        useFrontCamera: state.useFrontCamera));
  }
   switchCamera() {
    emit(ToggleCmState(
        openCamera: state.openCamera,
        enableMic: state.enableMic,
        useFrontCamera: !state.useFrontCamera));
  }
}
