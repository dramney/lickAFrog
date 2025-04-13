import '../../entities/user.dart';

abstract class FriendsState {}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final List<User> friends;
  FriendsLoaded(this.friends);
}

class FriendRequestsLoaded extends FriendsState {
  final List<User> requests;
  FriendRequestsLoaded(this.requests);
}

class UserSearchResult extends FriendsState {
  final User? user;
  UserSearchResult(this.user);
}

class UserNotFound extends FriendsState {}

class FriendsError extends FriendsState {
  final String message;
  FriendsError(this.message);
}