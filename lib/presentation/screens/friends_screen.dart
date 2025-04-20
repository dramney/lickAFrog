// Файл: presentation/screens/friends_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/presentation/widgets/frog_logo.dart';
import 'package:frog/domain/repositories/friends_repository.dart';

import '../../domain/blocs/friends/friends_bloc.dart';
import '../../domain/blocs/friends/friends_event.dart';
import '../../domain/blocs/friends/friends_state.dart';
import '../../domain/blocs/auth/auth_bloc.dart';
import '../../domain/blocs/auth/auth_state.dart';
import '../../domain/entities/user.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isMyFriends = true;
  String? _currentUserId;
  late FriendsRepository _friendsRepository;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabListener);
    _friendsRepository = context.read<FriendsRepository>();

    // Let's initialize in initState and then update from auth bloc
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUserId = authState.user.id;
    }

    // Використовуємо правильний клас WidgetsBinding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    if (_currentUserId != null) {
      if (_tabController.index == 0) {
        context.read<FriendsBloc>().add(LoadFriends(_currentUserId!));
      } else {
        context.read<FriendsBloc>().add(LoadFriendRequests(_currentUserId!));
      }
    }
  }

  void _tabListener() {
    setState(() {
      _isMyFriends = _tabController.index == 0;
    });
    if (_currentUserId == null) return;

    if (_tabController.index == 0) {
      context.read<FriendsBloc>().add(LoadFriends(_currentUserId!));
    } else {
      context.read<FriendsBloc>().add(LoadFriendRequests(_currentUserId!));
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Метод для отримання кількості лизів для користувача
  Future<int> _getLicksCount(String userId) async {
    try {
      // Отримуємо дані про жабу користувача через репозиторій
      final userDoc = await _friendsRepository.getUserFrogInfo(userId);
      if (userDoc != null && userDoc.containsKey('allLicks')) {
        return userDoc['allLicks'] as int;
      }
      return 0;
    } catch (e) {
      print('Error getting licks count: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Update current user ID when auth state changes
        if (authState is AuthAuthenticated) {
          _currentUserId = authState.user.id;
        } else {
          _currentUserId = null;
        }

        return Scaffold(
          backgroundColor: Color(0xFFB5D99C), // Зелений фон як на скріншотах
          appBar: AppBar(
            backgroundColor: Color(0xFFB5D99C),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Мої друзі',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: _currentUserId == null
              ? Center(child: Text('Будь ласка, увійдіть в систему'))
              : Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color(0xFF79A666), // Темно-зелений колір активного табу
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(text: 'Мої друзі'),
                            Tab(text: 'Заявки у друзі'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Введіть нікнейм користувача',
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if (_searchController.text.isNotEmpty) {
                            context.read<FriendsBloc>().add(SearchUser(_searchController.text));
                          }
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context.read<FriendsBloc>().add(SearchUser(value));
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<FriendsBloc, FriendsState>(
                  builder: (context, state) {
                    if (state is FriendsLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is FriendsLoaded && _isMyFriends) {
                      return _buildFriendsList(state.friends);
                    } else if (state is FriendRequestsLoaded && !_isMyFriends) {
                      return _buildRequestsList(state.requests);
                    } else if (state is UserSearchResult) {
                      return _buildSearchResult(state.user);
                    } else if (state is UserNotFound) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Користувача не знайдено', style: TextStyle(fontSize: 16)),
                        ),
                      );
                    } else if (state is FriendsError) {
                      return Center(child: Text(state.message));
                    } else {
                      return _isMyFriends ?
                      _buildEmptyState('У вас поки що немає друзів') :
                      _buildEmptyState('У вас немає заявок у друзі');
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(message, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildFriendsList(List<User> friends) {
    if (friends.isEmpty) {
      return _buildEmptyState('У вас поки що немає друзів');
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: _buildFrogAvatar(friend.frogRef),
            title: Text(friend.nickname),
            subtitle: FutureBuilder<int>(
              future: _getLicksCount(friend.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Завантаження...');
                }
                return Text('${snapshot.data ?? 0} лизів');
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () {
                if (_currentUserId != null) {
                  context.read<FriendsBloc>().add(
                      RemoveFriend(_currentUserId!, friend.id)
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestsList(List<User> requests) {
    if (requests.isEmpty) {
      return _buildEmptyState('У вас немає заявок у друзі');
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: _buildFrogAvatar(request.frogRef),
            title: Text(request.nickname),
            subtitle: FutureBuilder<int>(
              future: _getLicksCount(request.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Завантаження...');
                }
                return Text('${snapshot.data ?? 0} лизів');
              },
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    if (_currentUserId != null) {
                      context.read<FriendsBloc>().add(
                          AcceptRequest(_currentUserId!, request.id)
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    if (_currentUserId != null) {
                      context.read<FriendsBloc>().add(
                          RejectRequest(_currentUserId!, request.id)
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResult(User? user) {
    if (user == null) {
      return _buildEmptyState('Користувача не знайдено');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: _buildFrogAvatar(user.frogRef),
          title: Text(user.nickname),
          subtitle: FutureBuilder<int>(
            future: _getLicksCount(user.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Завантаження...');
              }
              return Text('${snapshot.data ?? 0} лизів');
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              if (_currentUserId != null) {
                context.read<FriendsBloc>().add(
                    SendRequest(_currentUserId!, user.id)
                );
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Заявку надіслано'))
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFrogAvatar(String frogRef) {
    return CircleAvatar(
        backgroundColor: Colors.transparent,
        child: FrogLogo(size: 40)
    );
  }
}