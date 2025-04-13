import 'package:flutter/material.dart';
import 'package:frog/domain/models/leaderboard_user.dart';

import 'podium_user.dart';

class LeaderboardPodium extends StatelessWidget {
  final List<LeaderboardUser> topThree;
  final Animation<double> podiumAnimation;

  static const Color goldColor = Color(0xFFFFD700);
  static const Color silverColor = Color(0xFFC0C0C0);
  static const Color bronzeColor = Color(0xFFCD7F32);

  const LeaderboardPodium({
    Key? key,
    required this.topThree,
    required this.podiumAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondPlace = topThree.length > 1 ? topThree[1] : null;
    final firstPlace = topThree.isNotEmpty ? topThree[0] : null;
    final thirdPlace = topThree.length > 2 ? topThree[2] : null;

    return AnimatedBuilder(
      animation: podiumAnimation,
      builder: (context, _) {
        return Stack(
          children: [
            // Користувачі з аватарами
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Друге місце (зліва)
                  if (secondPlace != null)
                    PodiumUser(
                      user: secondPlace,
                      avatarColor: const Color(0xFFFFC0CB).withOpacity(0.5),
                      avatarSize: 48 * podiumAnimation.value,
                      place: 2,
                      podiumAnimation: podiumAnimation,
                    ),

                  // Перше місце (центр)
                  if (firstPlace != null)
                    PodiumUser(
                      user: firstPlace,
                      isFirstPlace: true,
                      avatarColor: Colors.white,
                      borderColor: goldColor,
                      avatarSize: 60 * podiumAnimation.value,
                      place: 1,
                      podiumAnimation: podiumAnimation,
                    ),

                  // Третє місце (праворуч)
                  if (thirdPlace != null)
                    PodiumUser(
                      user: thirdPlace,
                      avatarColor: Colors.grey[300]!,
                      avatarSize: 48 * podiumAnimation.value,
                      place: 3,
                      podiumAnimation: podiumAnimation,
                    ),
                ],
              ),
            ),

            // П'єдестали
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // П'єдестал 2-го місця
                  Expanded(
                    flex: 2,
                    child: _buildPodiumBase(
                      height: 80 * podiumAnimation.value,
                      color: silverColor,
                      number: "2",
                      fontSize: 48 * podiumAnimation.value,
                    ),
                  ),

                  // П'єдестал 1-го місця
                  Expanded(
                    flex: 3,
                    child: _buildPodiumBase(
                      height: 100 * podiumAnimation.value,
                      color: goldColor,
                      number: "1",
                      fontSize: 64 * podiumAnimation.value,
                    ),
                  ),

                  // П'єдестал 3-го місця
                  Expanded(
                    flex: 2,
                    child: _buildPodiumBase(
                      height: 60 * podiumAnimation.value,
                      color: bronzeColor,
                      number: "3",
                      fontSize: 48 * podiumAnimation.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPodiumBase({
    required double height,
    required Color color,
    required String number,
    required double fontSize,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}