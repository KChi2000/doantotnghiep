import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:equatable/equatable.dart';

import '../../model/User.dart';

part 'fetch_image_state.dart';

class FetchImageCubit extends Cubit<FetchImageState> {
  FetchImageCubit() : super(FetchImageInitial());
  void getFromStream(Map<String, dynamic> snapshot) {
    emit(FetchImageLoading());
    var rs = Userinfo.fromJson(snapshot);
  
    Userinfo.userSingleton.saveProfilePic(rs.profilePic.toString());
    emit(FetchImageComplete(image: rs));
  }
}
