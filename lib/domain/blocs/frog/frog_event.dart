import 'package:equatable/equatable.dart';

abstract class FrogEvent extends Equatable {
  const FrogEvent();

  @override
  List<Object> get props => [];
}

class LoadFrogDataEvent extends FrogEvent {
  final String userId;

  const LoadFrogDataEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LickFrogEvent extends FrogEvent {
  final String userId;

  const LickFrogEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
