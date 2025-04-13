import 'package:flutter/material.dart';
import 'package:frog/domain/models/leaderboard_user.dart';

import 'leaderboard_podium.dart';
import 'player_list_item.dart';

class LeaderboardContent extends StatelessWidget {
  final List<LeaderboardUser> users;
  final double podiumVisibility;
  final Animation<double> podiumAnimation;
  final ScrollController scrollController;

  static const Color primaryColor = Color(0xFFAED89D);
  static const Color goldColor = Color(0xFFFFD700);
  static const Color silverColor = Color(0xFFC0C0C0);
  static const Color bronzeColor = Color(0xFFCD7F32);

  const LeaderboardContent({
    super.key,
    required this.users,
    required this.podiumVisibility,
    required this.podiumAnimation,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('Наразі немає гравців у рейтингу'));
    }

    final topThree = users.take(3).toList();
    final podiumHeight = 270.0 * podiumVisibility;
    final podiumOpacity = podiumVisibility;

    return Column(
      children: [
        // Podium area
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: podiumHeight,
          child: Opacity(
            opacity: podiumOpacity,
            child: LeaderboardPodium(
              topThree: topThree,
              podiumAnimation: podiumAnimation,
            ),
          ),
        ),

        // Players list
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(podiumVisibility > 0.1 ? 30 : 0),
              ),
              boxShadow: [
                if (podiumVisibility > 0.1)
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
              ],
            ),
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final place = index + 1;

                if (podiumVisibility > 0.1 && place <= 3) {
                  return const SizedBox.shrink();
                }

                final bool showMedal = place <= 3;
                final Color? medalColor = showMedal
                    ? place == 1
                    ? goldColor
                    : place == 2
                    ? silverColor
                    : bronzeColor
                    : null;

                return PlayerListItem(
                  user: user,
                  place: place,
                  medalColor: medalColor,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}