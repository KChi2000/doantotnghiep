part of 'fetch_location_cubit.dart';

 class FetchLocationState extends Equatable {
  Location location;
  FetchLocationState({required this.location});

  @override
  List<Object> get props => [location];
}

// class FetchLocationInitial extends FetchLocationState {}
