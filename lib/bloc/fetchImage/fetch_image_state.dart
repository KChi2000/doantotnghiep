part of 'fetch_image_cubit.dart';

abstract class FetchImageState extends Equatable {
  const FetchImageState();

  @override
  List<Object> get props => [];
}

class FetchImageInitial extends FetchImageState {}

class FetchImageLoading extends FetchImageState {}

class FetchImageComplete extends FetchImageState {
  Userinfo image;
  FetchImageComplete({required this.image});

  @override
  // TODO: implement props
  List<Object> get props => [image];
}
