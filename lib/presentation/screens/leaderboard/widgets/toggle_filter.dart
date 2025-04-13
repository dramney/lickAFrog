import 'package:flutter/material.dart';

class LeaderboardToggleFilter extends StatelessWidget {
  final bool isDaily;
  final Function(bool) onToggle;

  static const Color secondaryColor = Color(0xFF8DAE74);
  static const String dailyText = 'Денний';
  static const String allTimeText = 'За весь час';

  const LeaderboardToggleFilter({
    super.key,
    required this.isDaily,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              label: dailyText,
              isSelected: isDaily,
              onSelected: () => onToggle(true),
              icon: isDaily ? Icons.check : null,
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              label: allTimeText,
              isSelected: !isDaily,
              onSelected: () => onToggle(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: secondaryColor),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? secondaryColor : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}