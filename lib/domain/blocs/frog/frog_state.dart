import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FrogState extends Equatable {
  const FrogState();

  // Renaming the getter for allLicks
  int get totalLicks => 0; // Default implementation (can be overridden)
  String get frogStateName => ''; // Default implementation (can be overridden)

  @override
  List<Object?> get props => [];
}

class FrogInitial extends FrogState {}

class FrogLoading extends FrogState {}

class FrogLoaded extends FrogState {
  final String frogName;
  final int dayLicks;
  final int allLicks;

  const FrogLoaded({
    required this.frogName,
    required this.dayLicks,
    required this.allLicks,
  });

  @override
  String get frogStateName => frogName;
  @override
  int get totalLicks => allLicks; // Renamed getter

  @override
  List<Object?> get props => [frogName, dayLicks, allLicks];
}

class FrogLicked extends FrogState {
  final String frogName;
  final int dayLicks;
  final int allLicks;
  final FrogEffect effect;

  const FrogLicked({
    required this.frogName,
    required this.dayLicks,
    required this.allLicks,
    required this.effect,
  });

  @override
  String get frogStateName => frogName;
  @override
  int get totalLicks => allLicks; // Renamed getter

  @override
  List<Object?> get props => [frogName, dayLicks, allLicks, effect];
}

class FrogError extends FrogState {
  final String message;

  const FrogError({required this.message});

  @override
  List<Object?> get props => [message];
}



enum FrogEffectType {
  cosmic,
  rainbow,
  gold,
  dizzy,
  sleepy,
  giant,
  tiny,
  ninja,
  love,
}

class FrogEffect extends Equatable {
  final FrogEffectType type;
  final String message;
  final Color backgroundColor;
  final bool hasParticles;
  final bool hasStars;
  final bool hasColorChange;

  const FrogEffect({
    required this.type,
    required this.message,
    required this.backgroundColor,
    this.hasParticles = false,
    this.hasStars = false,
    this.hasColorChange = false,
  });

  @override
  List<Object?> get props => [type, message, backgroundColor, hasParticles, hasStars, hasColorChange];

  static FrogEffect getRandom() {
    final random = Random();
    final effectType = FrogEffectType.values[random.nextInt(FrogEffectType.values.length)];

    switch (effectType) {
      case FrogEffectType.cosmic:
        return const FrogEffect(
          type: FrogEffectType.cosmic,
          message: 'Космічна Жаба!',
          backgroundColor: Colors.blue,
          hasStars: true,
        );
      case FrogEffectType.rainbow:
        return const FrogEffect(
          type: FrogEffectType.rainbow,
          message: 'Веселкове Бачення!',
          backgroundColor: Colors.cyan,
          hasParticles: true,
          hasColorChange: true,
        );
      case FrogEffectType.gold:
        return const FrogEffect(
          type: FrogEffectType.gold,
          message: 'Золота Лихоманка!',
          backgroundColor: Color(0xFFFFD700),
          hasParticles: true,
        );
      case FrogEffectType.dizzy:
        return const FrogEffect(
          type: FrogEffectType.dizzy,
          message: 'Ого, запаморочення!',
          backgroundColor: Colors.purple,
          hasStars: true,
        );
      case FrogEffectType.sleepy:
        return const FrogEffect(
          type: FrogEffectType.sleepy,
          message: 'Жаба хоче спати...',
          backgroundColor: Colors.indigo,
          hasStars: true,
        );
      case FrogEffectType.giant:
        return const FrogEffect(
          type: FrogEffectType.giant,
          message: 'Величезна Жаба!',
          backgroundColor: Colors.orange,
          hasParticles: true,
        );
      case FrogEffectType.tiny:
        return const FrogEffect(
          type: FrogEffectType.tiny,
          message: 'Мікроскопічна Жаба!',
          backgroundColor: Colors.lightBlue,
          hasParticles: true,
        );
      case FrogEffectType.ninja:
        return const FrogEffect(
          type: FrogEffectType.ninja,
          message: 'Жаба-Ніндзя!',
          backgroundColor: Colors.black54,
          hasStars: true,
        );
      case FrogEffectType.love:
        return const FrogEffect(
          type: FrogEffectType.love,
          message: 'Закохана Жаба!',
          backgroundColor: Colors.pink,
          hasParticles: true,
        );
    }
  }
}
