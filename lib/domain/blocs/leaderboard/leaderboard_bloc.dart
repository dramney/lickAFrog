import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/repositories/leaderboard_repository.dart';
import 'leaderboard_event.dart';
import 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository leaderboardRepository;

  LeaderboardBloc(this.leaderboardRepository) : super(LeaderboardLoading()) {
    on<LoadLeaderboard>((event, emit) async {
      emit(LeaderboardLoading());
      try {
        final users = event.isDaily
            ? await leaderboardRepository.fetchDailyLeaderboard()
            : await leaderboardRepository.fetchAllTimeLeaderboard();
        emit(LeaderboardLoaded(users: users, isDaily: event.isDaily));
      } catch (e) {
        emit(LeaderboardError('Не вдалося завантажити рейтинг'));
      }
    });
  }
}
