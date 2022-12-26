import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'pick_image_state.dart';

class PickImageCubit extends Cubit<PickImageState> {
  PickImageCubit() : super(PickImageState());
  void pick(ImageSource typePick) async {
    XFile? image = await ImagePicker().pickImage(source: typePick);
    print('anhhhhhhhh: ${image.toString()}');
  }
}
