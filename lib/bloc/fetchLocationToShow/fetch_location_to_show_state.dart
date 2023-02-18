part of 'fetch_location_to_show_cubit.dart';

abstract class FetchLocationToShowState extends Equatable {
  const FetchLocationToShowState();

  @override
  List<Object> get props => [];
}

class FetchLocationToShowInitial extends FetchLocationToShowState {}

class FetchLocationToShowLoading extends FetchLocationToShowState {}

class FetchLocationToShowLoaded extends FetchLocationToShowState {
  List<Userinfo> list;
  GroupInfo selectedGroup;
  FetchLocationToShowLoaded(this.list, this.selectedGroup);
  @override
  List<Object> get props => [list, selectedGroup];
}
