import 'package:flutter/material.dart';

class GrassLogoT extends StatelessWidget {
  final double size;

  const GrassLogoT({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size, // Можна налаштувати висоту відповідно до зображення
      child: Image.asset(
        'assets/images/grass_teacup.png',
        fit: BoxFit.contain,
      ),
    );
  }
}