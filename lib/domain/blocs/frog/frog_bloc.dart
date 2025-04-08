import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/frog/frog_event.dart';
import 'package:frog/domain/blocs/frog/frog_state.dart';
import 'package:frog/domain/repositories/frog_repository.dart';

class FrogBloc extends Bloc<FrogEvent, FrogState> {
  final FrogRepository _frogRepository;

  FrogBloc({required FrogRepository frogRepository})
      : _frogRepository = frogRepository,
        super(FrogInitial()) {
    on<LoadFrogDataEvent>(_onLoadFrogData);
    on<LickFrogEvent>(_onLickFrog);
  }

  Future<void> _onLoadFrogData(
      LoadFrogDataEvent event, Emitter<FrogState> emit) async {
    emit(FrogLoading());
    try {
      final frogData = await _frogRepository.getFrogData(event.userId);
      emit(FrogLoaded(
        frogName: frogData.frogName,
        dayLicks: frogData.dayLicks,
        allLicks: frogData.allLicks,
      ));
    } catch (e) {
      emit(FrogError(message: e.toString()));
    }
  }

  Future<void> _onLickFrog(
      LickFrogEvent event, Emitter<FrogState> emit) async {
    try {
      final currentState = state;
      if (currentState is FrogLoaded || currentState is FrogLicked) {
        final String frogName;
        final int dayLicks;
        final int allLicks;

        if (currentState is FrogLoaded) {
          frogName = currentState.frogName;
          dayLicks = currentState.dayLicks + 1;
          allLicks = currentState.allLicks + 1;
        } else {
          final licked = currentState as FrogLicked;
          frogName = licked.frogName;
          dayLicks = licked.dayLicks + 1;
          allLicks = licked.allLicks + 1;
        }

        // Оновлюємо дані в базі даних
        await _frogRepository.updateLicks(
            event.userId,
            dayLicks: dayLicks,
            allLicks: allLicks
        );

        // Створюємо випадковий ефект
        final effect = FrogEffect.getRandom();

        // Показуємо ефект лизання
        emit(FrogLicked(
          frogName: frogName,
          dayLicks: dayLicks,
          allLicks: allLicks,
          effect: effect,
        ));

        // Через секунду повертаємося до звичайного стану
        await Future.delayed(const Duration(seconds: 1));
        emit(FrogLoaded(
          frogName: frogName,
          dayLicks: dayLicks,
          allLicks: allLicks,
        ));
      }
    } catch (e) {
      emit(FrogError(message: e.toString()));
    }
  }
}