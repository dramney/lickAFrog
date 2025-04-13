import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/friends_repository.dart';
import 'friends_event.dart';
import 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FriendsRepository _friendsRepository;

  FriendsBloc({required FriendsRepository friendsRepository})
      : _friendsRepository = friendsRepository,
        super(FriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<LoadFriendRequests>(_onLoadFriendRequests);
    on<SearchUser>(_onSearchUser);
    on<SendRequest>(_onSendRequest);
    on<AcceptRequest>(_onAcceptRequest);
    on<RejectRequest>(_onRejectRequest);
    on<RemoveFriend>(_onRemoveFriend);
  }

  Future<void> _onLoadFriends(LoadFriends event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      final friends = await _friendsRepository.getFriends(event.userId);
      emit(FriendsLoaded(friends));
    } catch (e) {
      emit(FriendsError('Не вдалось завантажити друзів: ${e.toString()}'));
    }
  }

  Future<void> _onLoadFriendRequests(LoadFriendRequests event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      final requests = await _friendsRepository.getFriendRequests(event.userId);
      emit(FriendRequestsLoaded(requests));
    } catch (e) {
      emit(FriendsError('Не вдалось завантажити заявки у друзі: ${e.toString()}'));
    }
  }

  Future<void> _onSearchUser(SearchUser event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      final user = await _friendsRepository.searchUserByNickname(event.nickname);
      if (user != null) {
        emit(UserSearchResult(user));
      } else {
        emit(UserNotFound());
      }
    } catch (e) {
      emit(FriendsError('Помилка пошуку користувача: ${e.toString()}'));
    }
  }

  Future<void> _onSendRequest(SendRequest event, Emitter<FriendsState> emit) async {
    try {
      await _friendsRepository.sendFriendRequest(event.currentUserId, event.targetUserId);
      add(LoadFriends(event.currentUserId));
    } catch (e) {
      emit(FriendsError('Не вдалось надіслати заявку: ${e.toString()}'));
    }
  }

  Future<void> _onAcceptRequest(AcceptRequest event, Emitter<FriendsState> emit) async {
    try {
      await _friendsRepository.acceptFriendRequest(event.currentUserId, event.senderUserId);
      add(LoadFriendRequests(event.currentUserId));
      add(LoadFriends(event.currentUserId));
    } catch (e) {
      emit(FriendsError('Не вдалось прийняти заявку: ${e.toString()}'));
    }
  }

  Future<void> _onRejectRequest(RejectRequest event, Emitter<FriendsState> emit) async {
    try {
      await _friendsRepository.rejectFriendRequest(event.currentUserId, event.senderUserId);
      add(LoadFriendRequests(event.currentUserId));
    } catch (e) {
      emit(FriendsError('Не вдалось відхилити заявку: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFriend(RemoveFriend event, Emitter<FriendsState> emit) async {
    try {
      await _friendsRepository.removeFriend(event.currentUserId, event.friendUserId);
      add(LoadFriends(event.currentUserId));
    } catch (e) {
      emit(FriendsError('Не вдалось видалити друга: ${e.toString()}'));
    }
  }
}
