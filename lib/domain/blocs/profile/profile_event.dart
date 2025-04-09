abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {
  final String userId;

  LoadProfileEvent({required this.userId});
}

class UpdateNicknameEvent extends ProfileEvent {
  final String userId;
  final String newNickname;

  UpdateNicknameEvent({required this.userId, required this.newNickname});
}

class UpdateFrogNameEvent extends ProfileEvent {
  final String userId;
  final String newFrogName;

  UpdateFrogNameEvent({required this.userId, required this.newFrogName});
}