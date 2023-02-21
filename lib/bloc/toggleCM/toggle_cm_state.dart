part of 'toggle_cm_cubit.dart';

 class ToggleCmState extends Equatable {
  bool openCamera;
  bool enableMic;
  bool useFrontCamera;
  ToggleCmState({required this.openCamera,required this.enableMic,required this.useFrontCamera});

  @override
  List<Object> get props => [openCamera,enableMic,useFrontCamera];
}

