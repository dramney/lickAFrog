import '../../entities/frog.dart';
import '../../entities/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final FrogData frogData;

  ProfileLoaded({required this.user, required this.frogData});
}

class ProfileUpdating extends ProfileState {
  final User user;
  final FrogData frogData;

  ProfileUpdating({required this.user, required this.frogData});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}