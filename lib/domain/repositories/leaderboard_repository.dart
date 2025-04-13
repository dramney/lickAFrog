import '../models/leaderboard_user.dart';

abstract class LeaderboardRepository {
  Future<List<LeaderboardUser>> fetchAllTimeLeaderboard();
  Future<List<LeaderboardUser>> fetchDailyLeaderboard();
  }
