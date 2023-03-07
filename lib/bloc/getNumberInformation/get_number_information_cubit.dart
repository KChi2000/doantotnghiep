import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:doantotnghiep/model/User.dart';
import 'package:equatable/equatable.dart';

part 'get_number_information_state.dart';

class GetNumberInformationCubit extends Cubit<GetNumberInformationState> {
  GetNumberInformationCubit() : super(GetNumberInformationState(number: 0));
  getNumberOfNotification(List<GroupInfo> listgroup) {
    List<Read> filterlist = [];
    listgroup.forEach((element) {
      List<Read>? notRead = element.isReadAr;
      filterlist.addAll(notRead!.where((element) =>
          element.Id.toString().substring(element.Id.toString().length - 28) ==
          Userinfo.userSingleton.uid).toList());
    });
    emit(GetNumberInformationState(number: filterlist.where((element) => element.isRead==false).toList().length));
  }
}
