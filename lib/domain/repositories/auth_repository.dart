import 'package:frog/domain/entities/user.dart';

abstract class AuthRepository {
  Future<bool> isAuthenticated();
  Future<User> login(String nickname, String password);
  Future<User> register(String nickname, String password);
  Future<User> getCurrentUser();
  Future<void> logout();
}