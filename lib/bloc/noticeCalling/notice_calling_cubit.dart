import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notice_calling_state.dart';

class NoticeCallingCubit extends Cubit<bool> {
  NoticeCallingCubit() : super(false);
  notificationCalling(bool vl){
    emit(vl);
  }
}
