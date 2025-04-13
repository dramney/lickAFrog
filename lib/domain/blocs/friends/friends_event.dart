abstract class FriendsEvent {}

class LoadFriends extends FriendsEvent {
  final String userId;
  LoadFriends(this.userId);
}

class LoadFriendRequests extends FriendsEvent {
  final String userId;
  LoadFriendRequests(this.userId);
}

class SearchUser extends FriendsEvent {
  final String nickname;
  SearchUser(this.nickname);
}

class SendRequest extends FriendsEvent {
  final String currentUserId;
  final String targetUserId;
  SendRequest(this.currentUserId, this.targetUserId);
}

class AcceptRequest extends FriendsEvent {
  final String currentUserId;
  final String senderUserId;
  AcceptRequest(this.currentUserId, this.senderUserId);
}

class RejectRequest extends FriendsEvent {
  final String currentUserId;
  final String senderUserId;
  RejectRequest(this.currentUserId, this.senderUserId);
}

class RemoveFriend extends FriendsEvent {
  final String currentUserId;
  final String friendUserId;
  RemoveFriend(this.currentUserId, this.friendUserId);
}