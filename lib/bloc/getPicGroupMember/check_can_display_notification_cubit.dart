import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';



class CheckCanDisplayNotificationCubit extends Cubit<bool> {
  CheckCanDisplayNotificationCubit() : super(true);
  void canDisplayNotification(bool vl){
    emit(vl);
  }
}
