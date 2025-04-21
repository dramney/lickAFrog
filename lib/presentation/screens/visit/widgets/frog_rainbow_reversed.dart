import 'package:flutter/material.dart';

class FrogRainbowRev extends StatelessWidget {
  final double size;

  const FrogRainbowRev({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/frog_rainbow_reversed.png',
        fit: BoxFit.contain,
      ),
    );
  }
}