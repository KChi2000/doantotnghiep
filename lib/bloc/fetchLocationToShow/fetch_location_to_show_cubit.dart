import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:equatable/equatable.dart';

part 'fetch_location_to_show_state.dart';

class FetchLocationToShowCubit extends Cubit<FetchLocationToShowState> {
  FetchLocationToShowCubit() : super(FetchLocationToShowInitial());
  fetchFromDb(GroupInfo gr) async {
    emit(FetchLocationToShowLoading());
    List<Userinfo> listlocation =
        await DatabaseService().fetchGrouplocation(gr);
    print('list of location is ${listlocation.length}');
    emit(FetchLocationToShowLoaded(listlocation, gr));
  }
}
