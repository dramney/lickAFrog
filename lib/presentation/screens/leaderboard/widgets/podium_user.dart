import 'package:flutter/material.dart';
import 'package:frog/domain/models/leaderboard_user.dart';

import '../../../widgets/frog_logo.dart';



class PodiumUser extends StatelessWidget {
  final LeaderboardUser user;
  final Color avatarColor;
  final int place;
  final bool isFirstPlace;
  final Color? borderColor;
  final double avatarSize;
  final Animation<double> podiumAnimation;

  static const Color goldColor = Color(0xFFFFD700);
  static const String licksText = 'лизів';

  const PodiumUser({
    Key? key,
    required this.user,
    required this.avatarColor,
    required this.place,
    required this.podiumAnimation,
    this.isFirstPlace = false,
    this.borderColor,
    this.avatarSize = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Корона для першого місця
        if (isFirstPlace) ...[
          Icon(
            Icons.emoji_events,
            color: goldColor,
            size: 28 * podiumAnimation.value,
          ),
          const SizedBox(height: 4),
        ],

        // Аватар з FrogLogo
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarColor,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: FrogLogo(size: avatarSize * 0.6),
        ),

        const SizedBox(height: 8),

        // Username
        Text(
          user.nickname,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),

        // Licks count
        Text(
          '${user.licks} $licksText',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}