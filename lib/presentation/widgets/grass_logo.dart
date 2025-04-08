import 'package:flutter/material.dart';

class GrassLogo extends StatelessWidget {
  final double size;

  const GrassLogo({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size, // Можна налаштувати висоту відповідно до зображення
      child: Image.asset(
        'assets/images/grass.png',
        fit: BoxFit.contain,
      ),
    );
  }
}