import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../NetworkProvider/Networkprovider.dart';
import '../../model/Group.dart';
import '../../model/User.dart';

part 'get_pic_group_member_state.dart';

class GetPicGroupMemberCubit extends Cubit<GetPicGroupMemberState> {
  GetPicGroupMemberCubit() : super(GetPicGroupMemberInitial());
  fetchFromDb(GroupInfo gr) async {
   if(gr.status != 'deleted'){
     emit(GetPicGroupMemberLoading());
    List<Userinfo> listlocation =
        await DatabaseService().fetchGrouplocation(gr);
   
    emit(GetPicGroupMemberLoaded(listlocation, gr));
   }else{
    emit(GetPicGroupMemberLoading());
    emit(GetPicGroupMemberInitial());
   }
  }
}
