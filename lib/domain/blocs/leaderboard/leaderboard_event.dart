abstract class LeaderboardEvent {}

class LoadLeaderboard extends LeaderboardEvent {
  final bool isDaily;

  LoadLeaderboard({required this.isDaily});
}
