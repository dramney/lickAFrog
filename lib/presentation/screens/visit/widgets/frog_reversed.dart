import 'package:flutter/material.dart';

class FrogLogoRev extends StatelessWidget {
  final double size;

  const FrogLogoRev({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/frog_reversed.png',
        fit: BoxFit.contain,
      ),
    );
  }
}