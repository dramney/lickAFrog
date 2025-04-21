import 'package:flutter/material.dart';

class FrogLick extends StatelessWidget {
  final double size;

  const FrogLick({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/frog_lick.png',
        fit: BoxFit.contain,
      ),
    );
  }
}