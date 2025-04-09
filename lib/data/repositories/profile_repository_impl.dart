import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore _firestore;

  FirebaseProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserProfile(String userId) async {
    final docSnapshot = await _firestore.collection('users').doc(userId).get();

    if (!docSnapshot.exists) {
      throw Exception('User not found');
    }

    final data = docSnapshot.data()!;

    return User(
      id: userId,
      nickname: data['nickname'] ?? '',
      frogRef: (data['frogRef'] as DocumentReference).id,
    );
  }
  @override
  Future<void> updateUserNickname(String userId, String newNickname) async {
    await _firestore.collection('users').doc(userId).update({
      'nickname': newNickname,
    });
  }

  @override
  Future<void> updateFrogName(String userId, String newFrogName) async {
    // Отримуємо документ користувача
    final userDoc = await _firestore.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      throw Exception('Користувача не знайдено');
    }

    final data = userDoc.data();
    final frogRef = data?['frogRef'] as DocumentReference?;

    if (frogRef == null) {
      throw Exception('Посилання на жабу відсутнє у даних користувача');
    }

    // Оновлюємо назву жаби
    await frogRef.update({'frogName': newFrogName});

  }


}