abstract class VisitEvent {}

class LoadVisitData extends VisitEvent {
  final String friendId;
  final String friendName;

  LoadVisitData(this.friendId, this.friendName);
}

class LickFriend extends VisitEvent {
  final String friendId;

  LickFriend(this.friendId);
}