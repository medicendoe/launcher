import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'clock_state.dart';

class ClockCubit extends Cubit<ClockState> {
  late final Timer _timer;
  ClockCubit() : super(ClockState.initial()) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateClock();
    });
  }

  // Método para actualizar la hora actual
  void updateClock() {
    final now = DateTime.now();
    emit(state.copyWith(
      hour: now.hour,
      minute: now.minute,
      day: now.day,
      month: now.month,
      year: now.year,
      weekday: now.weekday,
    ));
  }

  @override
  Future<void> close() {
    _timer.cancel(); // Cancelar el timer al cerrar el cubit
    return super.close();
  }
}