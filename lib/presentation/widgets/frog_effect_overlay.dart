import 'dart:math';
import 'package:flutter/material.dart';

import '../../domain/blocs/frog/frog_state.dart';

class StarParticle extends StatefulWidget {
  final Color color;
  final double size;

  const StarParticle({
    super.key,
    this.color = Colors.yellow,
    this.size = 20.0,
  });

  @override
  State<StarParticle> createState() => _StarParticleState();
}

class _StarParticleState extends State<StarParticle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  late double _left;
  late double _top;

  @override
  void initState() {
    super.initState();

    final random = Random();
    _left = random.nextDouble() * 300;
    _top = random.nextDouble() * 500;

    _controller = AnimationController(
      duration: Duration(milliseconds: 800 + random.nextInt(700)),
      vsync: this,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.4, curve: Curves.easeIn),
        reverseCurve: Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Icon(
                Icons.star,
                color: widget.color,
                size: widget.size,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ColorBubble extends StatefulWidget {
  final Color color;
  final double size;

  const ColorBubble({
    super.key,
    required this.color,
    this.size = 15.0,
  });

  @override
  State<ColorBubble> createState() => _ColorBubbleState();
}

class _ColorBubbleState extends State<ColorBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _position;
  late double _left;

  @override
  void initState() {
    super.initState();

    final random = Random();
    _left = random.nextDouble() * 300;

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000 + random.nextInt(1000)),
      vsync: this,
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _position = Tween<double>(begin: 600, end: random.nextDouble() * 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuad,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _left,
          top: _position.value,
          child: Opacity(
            opacity: _opacity.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}


class FrogEffectOverlay extends StatelessWidget {
  final FrogEffect effect;

  const FrogEffectOverlay({
    super.key,
    required this.effect,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color overlay
        Container(
          color: effect.backgroundColor.withOpacity(0.3),
          width: double.infinity,
          height: double.infinity,
        ),

        // Message in the center
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Text(
                  effect.message,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: effect.backgroundColor,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Stars if needed
        if (effect.hasStars)
          ...List.generate(15, (index) => StarParticle(
            color: Colors.amber,
            size: 10.0 + (index % 3) * 10,
          )),

        // Colored particles if needed
        if (effect.hasParticles)
          ...List.generate(20, (index) {
            final colors = [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
              Colors.pink,
              Colors.teal,
            ];
            return ColorBubble(
              color: colors[index % colors.length],
              size: 10.0 + (index % 5) * 3,
            );
          }),
      ],
    );
  }
}