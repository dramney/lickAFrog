import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/repositories/visit_repository.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_state.dart';
import 'visit_event.dart';
import 'visit_state.dart';

class VisitBloc extends Bloc<VisitEvent, VisitState> {
  final VisitRepository visitRepository;
  final AuthBloc authBloc;

  VisitBloc({
    required this.visitRepository,
    required this.authBloc,
  }) : super(VisitInitial()) {
    on<LoadVisitData>(_onLoadVisitData);
    on<LickFriend>(_onLickFriend);
  }

  Future<void> _onLoadVisitData(LoadVisitData event, Emitter<VisitState> emit) async {
    emit(VisitLoading());

    try {
      final authState = authBloc.state;
      if (authState is! AuthAuthenticated) {
        emit(VisitError('Користувач не авторизований'));
        return;
      }

      final currentUserId = authState.user.id;
      final currentUserName = authState.user.nickname;

      // Get visit count between users
      final visitCount = await visitRepository.getVisitCount(
          currentUserId,
          event.friendId
      );

      // Get friend's lick count
      final friendLicksCount = await visitRepository.getFriendLicksCount(event.friendId);

      // Record this visit
      await visitRepository.recordVisit(currentUserId, event.friendId);

      emit(VisitLoaded(
        currentUserId: currentUserId,
        currentUserName: currentUserName,
        friendId: event.friendId,
        friendName: event.friendName,
        visitCount: visitCount,
        friendLicksCount: friendLicksCount,
      ));
    } catch (e) {
      emit(VisitError('Помилка завантаження даних: $e'));
    }
  }

  Future<void> _onLickFriend(LickFriend event, Emitter<VisitState> emit) async {
    try {
      final currentState = state;
      if (currentState is VisitLoaded) {
        // Record the lick in the repository
        await visitRepository.recordLick(
            currentState.currentUserId,
            event.friendId
        );

        // Get updated lick count
        final updatedLicksCount = await visitRepository.getFriendLicksCount(event.friendId);

        emit(currentState.copyWith(
          friendLicksCount: updatedLicksCount,
          wasLicked: true,
        ));
      }
    } catch (e) {
      emit(VisitError('Помилка при лизанні жаби: $e'));
    }
  }
}