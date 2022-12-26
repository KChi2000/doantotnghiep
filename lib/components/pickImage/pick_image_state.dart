
part of 'pick_image_cubit.dart';

 class PickImageState extends Equatable {
  XFile? image;
   PickImageState({ this.image});

  @override
  List<Object> get props => [image!];
}

// class PickImageInitial extends PickImageState {}

// class PickImage extends PickImageState {}