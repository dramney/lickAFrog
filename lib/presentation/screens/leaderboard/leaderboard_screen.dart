import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:frog/domain/blocs/leaderboard/leaderboard_event.dart';
import 'package:frog/domain/blocs/leaderboard/leaderboard_state.dart';
import 'package:frog/domain/models/leaderboard_user.dart';
import 'package:frog/presentation/screens/leaderboard/widgets/leaderboard_content.dart';
import 'package:frog/presentation/screens/leaderboard/widgets/toggle_filter.dart';



class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  bool _isDaily = true;
  late AnimationController _controller;
  late Animation<double> _podiumAnimation;
  final ScrollController _scrollController = ScrollController();

  // Змінні для керування анімацією п'єдесталу
  double _podiumVisibility = 1.0;
  double _scrollOffset = 0.0;
  final double _podiumThreshold = 100.0;
  bool _isPodiumVisible = true;

  // Constants
  static const Color primaryColor = Color(0xFFAED89D);
  static const Color secondaryColor = Color(0xFF8DAE74);
  static const String titleText = 'Рейтинг гравців';
  static const String emptyLeaderboardText = 'Наразі немає гравців у рейтингу';
  static const String errorLoadingText = 'Помилка завантаження рейтингу';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _podiumAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _scrollController.addListener(_handleScroll);
    context.read<LeaderboardBloc>().add(LoadLeaderboard(isDaily: _isDaily));
    _controller.forward();
  }

  void _handleScroll() {
    final currentOffset = _scrollController.offset;
    final delta = currentOffset - _scrollOffset;

    // Прокручування вгору (дельта позитивна)
    if (delta > 0 && _isPodiumVisible && currentOffset > _podiumThreshold) {
      setState(() {
        _isPodiumVisible = false;
        _podiumVisibility = 0.0;
      });
    }
    // Прокручування вниз (дельта негативна)
    else if (delta < 0 && !_isPodiumVisible) {
      setState(() {
        _isPodiumVisible = true;
        _podiumVisibility = 1.0;
      });
    }

    // Зберігаємо поточне положення скролу для наступного порівняння
    _scrollOffset = currentOffset;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleLeaderboard(bool isDaily) {
    if (_isDaily == isDaily) return;

    setState(() {
      _isDaily = isDaily;
      _podiumVisibility = 1.0;
      _scrollOffset = 0.0;
      _isPodiumVisible = true;
    });

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    _controller.reset();
    context.read<LeaderboardBloc>().add(LoadLeaderboard(isDaily: isDaily));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          titleText,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          LeaderboardToggleFilter(
            isDaily: _isDaily,
            onToggle: _toggleLeaderboard,
          ),
          Expanded(
            child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
              builder: (context, state) {
                if (state is LeaderboardLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: secondaryColor),
                  );
                } else if (state is LeaderboardLoaded) {
                  final sortedUsers = List<LeaderboardUser>.from(state.users)
                    ..sort((a, b) => b.licks.compareTo(a.licks));

                  return LeaderboardContent(
                    users: sortedUsers,
                    podiumVisibility: _podiumVisibility,
                    podiumAnimation: _podiumAnimation,
                    scrollController: _scrollController,
                  );
                } else if (state is LeaderboardError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text(errorLoadingText));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}