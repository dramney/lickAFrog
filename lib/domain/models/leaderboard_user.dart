class LeaderboardUser {
  final String id;
  final String nickname;
  final int licks;

  LeaderboardUser({
    required this.id,
    required this.nickname,
    required this.licks,
  });

  factory LeaderboardUser.fromMap(
      String id,
      Map<String, dynamic> data, {
        bool isDaily = true,
      }) {
    return LeaderboardUser(
      id: id,
      nickname: data['nickname'] ?? 'Unknown',
      licks: data[isDaily ? 'dayLicks' : 'allLicks'] ?? 0,
    );
  }
}
