import 'package:flutter/material.dart';

class FrogLogo extends StatelessWidget {
  final double size;

  const FrogLogo({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/frog.png',
        fit: BoxFit.contain,
      ),
    );
  }
}