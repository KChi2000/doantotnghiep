import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/UserInfo.dart';

part 'fetch_image_state.dart';

class FetchImageCubit extends Cubit<FetchImageState> {
  FetchImageCubit() : super(FetchImageInitial());
  void getFromStream(Map<String, dynamic> snapshot) {
    emit(FetchImageLoading());
    var rs = Userinfo.fromJson(snapshot);
    print('get data from stream');
    emit(FetchImageComplete(image: rs));
  }
}
