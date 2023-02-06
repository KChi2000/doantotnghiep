import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:equatable/equatable.dart';

part 'get_invite_id_state.dart';

class GetInviteIdCubit extends Cubit<GetInviteIdState> {
  GetInviteIdCubit() : super(GetInviteIdState(GroupInfo()));
  void getInviteid(String grId)async{
    var data = await DatabaseService().getInvitedId(grId);
    GroupInfo group =
          GroupInfo.fromJson(data.docs[0].data() as Map<String, dynamic>);
    emit(GetInviteIdState(group));
   print('data invite id: ${group.groupName}');
  }
}
