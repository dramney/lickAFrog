import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frog/domain/models/leaderboard_user.dart';
import 'package:frog/domain/repositories/leaderboard_repository.dart';
import 'package:frog/domain/entities/frog.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final FirebaseFirestore _firestore;

  LeaderboardRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<List<LeaderboardUser>> fetchDailyLeaderboard() async {
    final usersSnapshot = await _fetchLeaderboard();
    return await _mapSnapshotToLeaderboardUsers(usersSnapshot, isDaily: true);
  }

  @override
  Future<List<LeaderboardUser>> fetchAllTimeLeaderboard() async {
    final usersSnapshot = await _fetchLeaderboard();
    return await _mapSnapshotToLeaderboardUsers(usersSnapshot, isDaily: false);
  }

  // Отримуємо користувачів
  Future<QuerySnapshot<Map<String, dynamic>>> _fetchLeaderboard() {
    return _firestore
        .collection('users')
        .limit(50)
        .get();
  }

  // Перетворюємо дані користувачів на LeaderboardUser
  Future<List<LeaderboardUser>> _mapSnapshotToLeaderboardUsers(
      QuerySnapshot<Map<String, dynamic>> snapshot, {
        required bool isDaily,
      }) async {
    List<LeaderboardUser> users = [];

    for (var doc in snapshot.docs) {
      final userData = doc.data();
      final userId = doc.id;

      // Отримуємо актуальні дані жаби
      final frogData = await _getFrogData(userId);

      // Створюємо LeaderboardUser
      final licks = isDaily ? frogData.dayLicks : frogData.allLicks;
      final leaderboardUser = LeaderboardUser(
        id: userId,
        nickname: userData['nickname'] ?? 'Unknown',
        licks: licks,
      );

      users.sort((a, b) => b.licks.compareTo(a.licks));

      users.add(leaderboardUser);
    }

    return users;
  }

  Future<FrogData> _getFrogData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      print('User Document: ${userDoc.data()}');

      if (!userDoc.exists) {
        throw Exception('Користувача не знайдено');
      }

      final data = userDoc.data()!;
      final Timestamp? lastLickedTimestamp = data['lastLicked'];
      final DateTime now = DateTime.now();
      final DateTime lastLickedDate = lastLickedTimestamp?.toDate() ?? now;

      print('Last Licked Date: $lastLickedDate');

      final isNewDay = now.day != lastLickedDate.day ||
          now.month != lastLickedDate.month ||
          now.year != lastLickedDate.year;

      print('Is New Day: $isNewDay');

      final frogRef = data['frogRef'] as DocumentReference;
      print('Frog Reference: $frogRef');

      final frogDoc = await frogRef.get();
      if (!frogDoc.exists) {
        throw Exception('Жабу не знайдено');
      }

      final frogData = frogDoc.data() as Map<String, dynamic>;

      if (isNewDay) {
        // Скидаємо денні лизи у жаби та оновлюємо дату лизання в юзера
        await Future.wait([
          frogRef.update({'dayLicks': 0}),
          _firestore.collection('users').doc(userId).update({
            'lastLicked': FieldValue.serverTimestamp(),
          }),
        ]);
      }

      return FrogData(
        frogName: frogData['frogName'],
        dayLicks: isNewDay ? 0 : frogData['dayLicks'] as int? ?? 0,
        allLicks: frogData['allLicks'] as int? ?? 0,
      );
    } catch (e) {
      print('Error fetching frog data: ${e.toString()}');
      throw Exception('Помилка отримання даних жаби: ${e.toString()}');
    }
  }


}
