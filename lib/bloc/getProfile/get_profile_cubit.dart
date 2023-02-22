import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/model/User.dart';
import 'package:equatable/equatable.dart';

part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  GetProfileCubit() : super(GetProfileState());
  void getStreamProfile() async {
    Stream? stream = await DatabaseService().getProfileImage();
    emit(GetProfileState(stream: stream));
  }
}
