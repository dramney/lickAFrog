import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_state.dart';
import 'package:frog/domain/blocs/frog/frog_bloc.dart';
import 'package:frog/domain/blocs/frog/frog_event.dart';
import 'package:frog/domain/blocs/frog/frog_state.dart';
import 'package:frog/presentation/widgets/frog_logo.dart';
import 'package:frog/presentation/widgets/grass_logo.dart';
import 'package:frog/presentation/widgets/frog_effect_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isLicking = false;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<FrogBloc>().add(LoadFrogDataEvent(userId: authState.user.id));
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _finishLick(BuildContext context, String userId) {
    if (_isLicking) {
      context.read<FrogBloc>().add(LickFrogEvent(userId: userId));
      setState(() {
        _isLicking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA9C683),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            return SafeArea(
                child:
                BlocBuilder<FrogBloc, FrogState>(
                  builder: (context, frogState) {
                    // Значення за замовчуванням
                    String frogName = 'Жабка';
                    int licks = 0;
                    bool isLoaded = false;

                    // Якщо дані завантажено або жабу лизнули
                    if (frogState is FrogLoaded) {
                      frogName = frogState.frogName;
                      licks = frogState.dayLicks;
                      isLoaded = true;
                    } else if (frogState is FrogLicked) {
                      frogName = frogState.frogName;
                      licks = frogState.dayLicks;
                      isLoaded = true;
                    } else if (frogState is FrogError) {
                      return Center(child: Text('Помилка: ${frogState.message}'));
                    }

                    if (!isLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Лизів: $licks',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black38,
                                              offset: Offset(2.0, 2.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (licks < 6)
                                        const Text(
                                          'Проведіть по жабці щоб лизнути',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.person, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    // Відкриття профілю
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 70,
                          right: 16,
                          child: Column(
                            children: [
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.group, color: Colors.white),
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.emoji_events, color: Colors.white),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                frogName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  const GrassLogo(size: 420),
                                  GestureDetector(
                                    onPanStart: (details) {
                                      setState(() {
                                        _isLicking = true;
                                      });
                                      _bounceController.forward();
                                    },
                                    onPanEnd: (details) {
                                      _bounceController.reverse();
                                      _finishLick(context, authState.user.id);
                                    },
                                    onPanCancel: () {
                                      _bounceController.reverse();
                                      setState(() {
                                        _isLicking = false;
                                      });
                                    },
                                    child: Builder(
                                      builder: (context) {
                                        if (frogState is FrogLicked) {
                                          final effectType = frogState.effect.type;

                                          switch (effectType) {
                                            case FrogEffectType.dizzy:
                                              _rotationController.repeat();
                                              return AnimatedBuilder(
                                                animation: _rotationController,
                                                builder: (context, child) {
                                                  return Transform.rotate(
                                                    angle: _rotationAnimation.value,
                                                    child: const FrogLogo(size: 180),
                                                  );
                                                },
                                              );
                                            case FrogEffectType.giant:
                                              return Transform.scale(
                                                scale: 1.5,
                                                child: const FrogLogo(size: 180),
                                              );
                                            case FrogEffectType.tiny:
                                              return const FrogLogo(size: 90);
                                            case FrogEffectType.love:
                                              return AnimatedBuilder(
                                                animation: _pulseController,
                                                builder: (context, child) {
                                                  return Transform.scale(
                                                    scale: _pulseAnimation.value,
                                                    child: const FrogLogo(size: 180),
                                                  );
                                                },
                                              );
                                            default:
                                              return AnimatedBuilder(
                                                animation: _bounceAnimation,
                                                builder: (context, child) {
                                                  return Transform.scale(
                                                    scale: _bounceAnimation.value,
                                                    child: child,
                                                  );
                                                },
                                                child: const FrogLogo(size: 180),
                                              );
                                          }
                                        } else {
                                          _rotationController.stop();
                                          _rotationController.reset();

                                          return AnimatedBuilder(
                                            animation: _bounceAnimation,
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scale: _bounceAnimation.value,
                                                child: child,
                                              );
                                            },
                                            child: const FrogLogo(size: 180),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (frogState is FrogLicked)
                          FrogEffectOverlay(effect: frogState.effect),
                      ],
                    );
                  },
                )

            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
