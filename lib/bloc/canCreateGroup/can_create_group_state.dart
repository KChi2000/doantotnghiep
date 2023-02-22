part of 'can_create_group_cubit.dart';

 class CanCreateGroupState extends Equatable {
  bool canCreate;
  CanCreateGroupState({required this.canCreate});

  @override
  List<Object> get props => [canCreate];
}

