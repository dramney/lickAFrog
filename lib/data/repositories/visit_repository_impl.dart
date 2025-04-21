import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frog/domain/repositories/visit_repository.dart';

class VisitRepositoryImpl implements VisitRepository {
  final FirebaseFirestore _firestore;

  VisitRepositoryImpl(this._firestore);

  @override
  Future<int> getVisitCount(String userId, String friendId) async {
    final visitDoc = await _firestore
        .collection('visits')
        .doc('${userId}_$friendId')
        .get();

    if (visitDoc.exists && visitDoc.data()!.containsKey('count')) {
      return visitDoc.data()!['count'] as int;
    }
    return 0;
  }

  @override
  Future<int> getFriendLicksCount(String friendId) async {
    final userDoc = await _firestore
        .collection('users')
        .doc(friendId)
        .get();

    if (userDoc.exists && userDoc.data()!.containsKey('allLicks')) {
      return userDoc.data()!['allLicks'] as int;
    }
    return 0;
  }

  @override
  Future<void> recordVisit(String userId, String friendId) async {
    final visitRef = _firestore.collection('visits').doc('${userId}_$friendId');
    final visitDoc = await visitRef.get();

    if (visitDoc.exists) {
      await visitRef.update({
        'lastVisit': FieldValue.serverTimestamp(),
        'count': FieldValue.increment(1),
      });
    } else {
      await visitRef.set({
        'userId': userId,
        'friendId': friendId,
        'lastVisit': FieldValue.serverTimestamp(),
        'count': 1,
      });
    }
  }

  @override
  Future<void> recordLick(String userId, String friendId) async {
    // Update friend's frog lick count
    await _firestore.collection('users').doc(friendId).update({
      'allLicks': FieldValue.increment(1),
    });

    // Record lick in history
    await _firestore.collection('licks').add({
      'fromUserId': userId,
      'toUserId': friendId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}