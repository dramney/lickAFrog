import 'package:flutter/material.dart';

class FrogRainbow extends StatelessWidget {
  final double size;

  const FrogRainbow({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/frog_rainbow.png',
        fit: BoxFit.contain,
      ),
    );
  }
}