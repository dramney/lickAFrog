import 'package:flutter/material.dart';
import 'package:frog/domain/models/leaderboard_user.dart';

import '../../../widgets/frog_logo.dart';

class PlayerListItem extends StatelessWidget {
  final LeaderboardUser user;
  final int place;
  final Color? medalColor;

  static const Color primaryColor = Color(0xFFAED89D);
  static const Color secondaryColor = Color(0xFF8DAE74);
  static const Color goldColor = Color(0xFFFFD700);
  static const Color silverColor = Color(0xFFC0C0C0);
  static const Color bronzeColor = Color(0xFFCD7F32);
  static const String licksText = 'лизів';

  const PlayerListItem({
    super.key,
    required this.user,
    required this.place,
    this.medalColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        border: place <= 3
            ? Border.all(
          color: place == 1
              ? goldColor.withOpacity(0.3)
              : place == 2
              ? silverColor.withOpacity(0.3)
              : bronzeColor.withOpacity(0.3),
          width: 1,
        )
            : null,
      ),
      child: Row(
        children: [
          // Номер місця або медаль
          _buildPlaceIndicator(),
          const SizedBox(width: 12),

          // Аватар користувача з FrogLogo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const FrogLogo(size: 24),
          ),
          const SizedBox(width: 12),

          // Інформація про користувача
          Expanded(
            child: Text(
              user.nickname,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Кількість балів
          Text(
            '${user.licks} $licksText',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: secondaryColor,
            ),
          ),

          // Іконка нагороди для топ-користувачів
          if (place <= 3 && medalColor == null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.workspace_premium,
              color: place == 1
                  ? goldColor
                  : place == 2
                  ? silverColor
                  : bronzeColor,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceIndicator() {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: medalColor ?? const Color(0xFFF0F0F0),
        boxShadow: medalColor != null
            ? [
          BoxShadow(
            color: medalColor!.withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 1,
          )
        ]
            : null,
      ),
      child: medalColor != null
          ? Icon(
        place == 1 ? Icons.emoji_events : Icons.circle,
        color: Colors.white,
        size: place == 1 ? 16 : 14,
      )
          : Text(
        '$place',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}