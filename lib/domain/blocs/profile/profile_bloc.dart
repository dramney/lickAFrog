import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/profile/profile_event.dart';
import 'package:frog/domain/blocs/profile/profile_state.dart';

import '../../repositories/auth_repository.dart';
import '../../repositories/frog_repository.dart';
import '../../repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final FrogRepository frogRepository;
  final ProfileRepository profileRepository;

  ProfileBloc({
    required this.authRepository,
    required this.frogRepository,
    required this.profileRepository,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateNicknameEvent>(_onUpdateNickname);
    on<UpdateFrogNameEvent>(_onUpdateFrogName);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit
  ) async {
    emit(ProfileLoading());

    try {
      // Use the current repositories to get user and frog data
      final user = await authRepository.getCurrentUser();
      final frogData = await frogRepository.getFrogData(event.userId);

      emit(ProfileLoaded(user: user, frogData: frogData));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateNickname(
    UpdateNicknameEvent event,
    Emitter<ProfileState> emit
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      // First update the state to show loading
      emit(ProfileUpdating(
        user: currentState.user,
        frogData: currentState.frogData,
      ));

      try {
        // Update the nickname in the repository
        await profileRepository.updateUserNickname(
          event.userId,
          event.newNickname
        );

        // Get the updated user
        final updatedUser = await authRepository.getCurrentUser();

        // Emit the updated state
        emit(ProfileLoaded(
          user: updatedUser,
          frogData: currentState.frogData,
        ));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateFrogName(
    UpdateFrogNameEvent event,
    Emitter<ProfileState> emit
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      // First update the state to show loading
      emit(ProfileUpdating(
        user: currentState.user,
        frogData: currentState.frogData,
      ));

      try {
        // Update the frog name in the repository
        await profileRepository.updateFrogName(
          event.userId,
          event.newFrogName
        );

        // Get the updated frog data
        final updatedFrogData = await frogRepository.getFrogData(event.userId);

        // Emit the updated state
        emit(ProfileLoaded(
          user: currentState.user,
          frogData: updatedFrogData,
        ));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }
}