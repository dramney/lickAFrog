// Файл: data/repositories/friends_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/friends_repository.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FirebaseFirestore _firestore;

  FriendsRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<List<User>> getFriends(String userId) async {
    try {
      // Отримуємо документ користувача
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists || !(userDoc.data()?.containsKey('friends') ?? false)) {
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
          // Створюємо об'єкт User безпосередньо, без використання UserModel
          final data = friendDoc.data() as Map<String, dynamic>;

          // Отримуємо frogRef як шлях до документа
          String frogRef = '';
          if (data['frogRef'] != null) {
            if (data['frogRef'] is DocumentReference) {
              // Якщо frogRef є посиланням на документ
              frogRef = (data['frogRef'] as DocumentReference).path.split('/').last;
            } else if (data['frogRef'] is String) {
              // Якщо frogRef є стрічкою
              frogRef = data['frogRef'].toString().split('/').last;
            }
          }

          friends.add(User(
            id: friendDoc.id,
            nickname: data['nickname'] ?? '',
            frogRef: frogRef,
          ));
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

      if (!userDoc.exists || !(userDoc.data()?.containsKey('friendRequests') ?? false)) {
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
          // Створюємо об'єкт User безпосередньо, без використання UserModel
          final data = requesterDoc.data() as Map<String, dynamic>;

          // Отримуємо frogRef як шлях до документа
          String frogRef = '';
          if (data['frogRef'] != null) {
            if (data['frogRef'] is DocumentReference) {
              // Якщо frogRef є посиланням на документ
              frogRef = (data['frogRef'] as DocumentReference).path.split('/').last;
            } else if (data['frogRef'] is String) {
              // Якщо frogRef є стрічкою
              frogRef = data['frogRef'].toString().split('/').last;
            }
          }

          requests.add(User(
            id: requesterDoc.id,
            nickname: data['nickname'] ?? '',
            frogRef: frogRef,
          ));
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

      final doc = querySnapshot.docs.first;
      final data = doc.data();

      // Отримуємо frogRef як шлях до документа
      String frogRef = '';
      if (data['frogRef'] != null) {
        if (data['frogRef'] is DocumentReference) {
          // Якщо frogRef є посиланням на документ
          frogRef = (data['frogRef'] as DocumentReference).path.split('/').last;
        } else if (data['frogRef'] is String) {
          // Якщо frogRef є стрічкою
          frogRef = data['frogRef'].toString().split('/').last;
        }
      }

      return User(
        id: doc.id,
        nickname: data['nickname'] ?? '',
        frogRef: frogRef,
      );
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