import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:doantotnghiep/model/User.dart';
import 'package:equatable/equatable.dart';

part 'fetch_location_to_show_state.dart';

class FetchLocationToShowCubit extends Cubit<FetchLocationToShowState> {
  FetchLocationToShowCubit() : super(FetchLocationToShowInitial());
  fetchFromDb(GroupInfo gr) async {
   if(gr.status != 'deleted'){
     emit(FetchLocationToShowLoading());
    List<Userinfo> listlocation =
        await DatabaseService().fetchGrouplocation(gr);
   
    emit(FetchLocationToShowLoaded(listlocation, gr));
   }else{
    emit(FetchLocationToShowLoading());
    emit(FetchLocationToShowInitial());
   }
  }
  backToInitial(){
     emit(FetchLocationToShowLoading());
    emit(FetchLocationToShowInitial());
  }
}
