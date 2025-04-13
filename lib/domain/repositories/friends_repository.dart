import '../entities/user.dart';

abstract class FriendsRepository {
  Future<List<User>> getFriends(String userId);
  Future<List<User>> getFriendRequests(String userId);
  Future<User?> searchUserByNickname(String nickname);
  Future<void> sendFriendRequest(String currentUserId, String targetUserId);
  Future<void> acceptFriendRequest(String currentUserId, String senderUserId);
  Future<void> rejectFriendRequest(String currentUserId, String senderUserId);
  Future<void> removeFriend(String currentUserId, String friendUserId);
  Future<Map<String, dynamic>?> getUserFrogInfo(String userId);
}