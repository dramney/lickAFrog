import '../entities/user.dart';

abstract class ProfileRepository {
  Future<User> getUserProfile(String userId);
  Future<void> updateUserNickname(String userId, String newNickname);
  Future<void> updateFrogName(String userId, String newFrogName);
}