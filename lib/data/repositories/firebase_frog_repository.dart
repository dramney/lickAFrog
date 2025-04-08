import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frog/domain/repositories/frog_repository.dart';

import '../../domain/entities/frog.dart';

class FirebaseFrogRepository implements FrogRepository {
  final FirebaseFirestore _firestore;

  FirebaseFrogRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future<FrogData> getFrogData(String userId) async {
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

      if (isNewDay) {
        await _firestore.collection('users').doc(userId).update({
          'dayLicks': 0,
          'lastLicked': FieldValue.serverTimestamp(),
        });
      }

      final frogRef = data['frogRef'] as DocumentReference;
      print('Frog Reference: $frogRef');

      final frogDoc = await frogRef.get();
      if (!frogDoc.exists) {
        throw Exception('Жабу не знайдено');
      }

      print('Frog Document: ${frogDoc.data()}');

      final frogData = frogDoc.data() as Map<String, dynamic>;

      return FrogData(
        frogName: frogData['frogName'] as String? ?? 'Жабка',
        dayLicks: isNewDay ? 0 : frogData['dayLicks'] as int? ?? 0,
        allLicks: frogData['allLicks'] as int? ?? 0,
      );

    } catch (e) {
      print('Error fetching frog data: ${e.toString()}');
      throw Exception('Помилка отримання даних жаби: ${e.toString()}');
    }
  }

  @override
  Future<void> updateLicks(String userId, {required int dayLicks, required int allLicks}) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('Користувача не знайдено');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final frogRef = userData['frogRef'] as DocumentReference;

      await frogRef.update({
        'dayLicks': dayLicks,
        'allLicks': allLicks,
      });

      await _firestore.collection('users').doc(userId).update({
        'lastLicked': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Помилка оновлення лизань: ${e.toString()}');
    }
  }

}
