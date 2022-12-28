import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'pick_image_state.dart';

class PickImageCubit extends Cubit<PickImageState> {
  PickImageCubit() : super(PickImageInitial());
  void pick(ImageSource typePick) async {
    XFile? image = await ImagePicker().pickImage(source: typePick);
   emit(PickImage(image: image!));
  }
}
