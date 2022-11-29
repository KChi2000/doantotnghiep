import 'package:bloc/bloc.dart';
import 'package:doantotnghiep/services/database_service.dart';
import 'package:equatable/equatable.dart';

part 'get_invite_id_state.dart';

class GetInviteIdCubit extends Cubit<GetInviteIdState> {
  GetInviteIdCubit() : super(GetInviteIdState(''));
  void getInviteid(String grId)async{
    var data = await DatabaseService().getInvitedId(grId);
    emit(GetInviteIdState(data.docs[0]['inviteId']));
    print('data invite id: ${data.docs[0]['inviteId']}');
  }
}
