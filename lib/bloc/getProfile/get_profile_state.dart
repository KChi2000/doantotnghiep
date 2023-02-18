part of 'get_profile_cubit.dart';

class GetProfileState extends Equatable {
  Stream? stream;
  GetProfileState({this.stream});

  @override
  List<dynamic> get props => [stream];
}

// class GetProfileInitial extends GetProfileState {}
