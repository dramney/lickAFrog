abstract class AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String nickname;
  final String password;

  LoginEvent({
    required this.nickname,
    required this.password,
  });
}

class RegisterEvent extends AuthEvent {
  final String nickname;
  final String password;

  RegisterEvent({
    required this.nickname,
    required this.password,
  });
}

class LogoutEvent extends AuthEvent {}