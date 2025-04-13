import '../../models/leaderboard_user.dart';

abstract class LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardUser> users;
  final bool isDaily;

  LeaderboardLoaded({required this.users, required this.isDaily});
}

class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError(this.message);
}
