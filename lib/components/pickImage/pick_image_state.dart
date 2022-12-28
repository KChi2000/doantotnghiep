
part of 'pick_image_cubit.dart';

abstract class PickImageState extends Equatable {
 
PickImageState();
   @override
  List<Object> get props => [];
}

class PickImageInitial extends PickImageState {
   PickImageInitial();

   @override
  List<Object> get props => [];
}

class PickImage extends PickImageState {
  XFile image;
   PickImage( {required this.image});

  @override
  // TODO: implement props
  List<Object> get props => [image];

}