import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/friends_repository.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FirebaseFirestore _firestore;

  FriendsRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // Helper method to safely extract frogRef ID
  String _extractFrogRefId(dynamic frogRefData) {
    if (frogRefData == null) return '';

    if (frogRefData is DocumentReference) {
      return frogRefData.id; // Get the ID directly
    } else if (frogRefData is String) {
      // If it's a path, extract the last part (id)
      return frogRefData.split('/').last;
    }
    return '';
  }

  // Helper method to convert Firestore data to User object
  User _documentToUser(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return User(id: doc.id, nickname: '', frogRef: '');
    }

    return User(
      id: doc.id,
      nickname: data['nickname'] ?? '',
      frogRef: _extractFrogRefId(data['frogRef']),
    );
  }

  @override
  Future<List<User>> getFriends(String userId) async {
    try {
      // Отримуємо документ користувача
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists || !userDoc.data()!.containsKey('friends')) {
        return [];
      }

      // Отримуємо список ID друзів
      List<dynamic> friendIds = userDoc.data()?['friends'] ?? [];

      if (friendIds.isEmpty) {
        return [];
      }

      // Отримуємо дані всіх друзів
      List<User> friends = [];
      for (String friendId in List<String>.from(friendIds)) {
        final friendDoc = await _firestore.collection('users').doc(friendId).get();
        if (friendDoc.exists) {
          friends.add(_documentToUser(friendDoc));
        }
      }

      return friends;
    } catch (e) {
      print('Error getting friends: $e');
      return [];
    }
  }

  @override
  Future<List<User>> getFriendRequests(String userId) async {
    try {
      // Отримуємо документ користувача
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists || !userDoc.data()!.containsKey('friendRequests')) {
        return [];
      }

      // Отримуємо список ID запитів у друзі
      List<dynamic> requestIds = userDoc.data()?['friendRequests'] ?? [];

      if (requestIds.isEmpty) {
        return [];
      }

      // Отримуємо дані всіх користувачів, які надіслали запити
      List<User> requests = [];
      for (String requestId in List<String>.from(requestIds)) {
        final requesterDoc = await _firestore.collection('users').doc(requestId).get();
        if (requesterDoc.exists) {
          requests.add(_documentToUser(requesterDoc));
        }
      }

      return requests;
    } catch (e) {
      print('Error getting friend requests: $e');
      return [];
    }
  }

  @override
  Future<User?> searchUserByNickname(String nickname) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return _documentToUser(querySnapshot.docs.first);
    } catch (e) {
      print('Error searching user: $e');
      return null;
    }
  }

  @override
  Future<void> sendFriendRequest(String currentUserId, String targetUserId) async {
    try {
      // Додаємо ID поточного користувача до списку запитів у друзі цільового користувача
      await _firestore.collection('users').doc(targetUserId).update({
        'friendRequests': FieldValue.arrayUnion([currentUserId])
      });
    } catch (e) {
      print('Error sending friend request: $e');
      throw Exception('Failed to send friend request');
    }
  }

  @override
  Future<void> acceptFriendRequest(String currentUserId, String senderUserId) async {
    try {
      // Додаємо користувачів до списків друзів один одного та видаляємо запит
      await _firestore.collection('users').doc(currentUserId).update({
        'friends': FieldValue.arrayUnion([senderUserId]),
        'friendRequests': FieldValue.arrayRemove([senderUserId])
      });

      await _firestore.collection('users').doc(senderUserId).update({
        'friends': FieldValue.arrayUnion([currentUserId])
      });
    } catch (e) {
      print('Error accepting friend request: $e');
      throw Exception('Failed to accept friend request');
    }
  }

  @override
  Future<void> rejectFriendRequest(String currentUserId, String senderUserId) async {
    try {
      // Видаляємо запит зі списку запитів у друзі
      await _firestore.collection('users').doc(currentUserId).update({
        'friendRequests': FieldValue.arrayRemove([senderUserId])
      });
    } catch (e) {
      print('Error rejecting friend request: $e');
      throw Exception('Failed to reject friend request');
    }
  }

  @override
  Future<void> removeFriend(String currentUserId, String friendUserId) async {
    try {
      // Видаляємо користувачів зі списків друзів один одного
      await _firestore.collection('users').doc(currentUserId).update({
        'friends': FieldValue.arrayRemove([friendUserId])
      });

      await _firestore.collection('users').doc(friendUserId).update({
        'friends': FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      print('Error removing friend: $e');
      throw Exception('Failed to remove friend');
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserFrogInfo(String userId) async {
    try {
      // Спочатку отримуємо документ користувача, щоб знайти посилання на жабу
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return null;
      }

      final userData = userDoc.data();
      if (userData == null || userData['frogRef'] == null) {
        return null;
      }

      // Отримуємо посилання на документ жаби
      DocumentReference frogRef;
      if (userData['frogRef'] is DocumentReference) {
        frogRef = userData['frogRef'] as DocumentReference;
      } else if (userData['frogRef'] is String) {
        // Якщо frogRef є стрічкою, конвертуємо її в DocumentReference
        final path = userData['frogRef'].toString();
        frogRef = _firestore.doc(path);
      } else {
        return null;
      }

      // Отримуємо документ жаби
      final frogDoc = await frogRef.get();

      if (!frogDoc.exists) {
        return null;
      }

      return frogDoc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error getting user frog info: $e');
      return null;
    }
  }
}