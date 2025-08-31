// File: lib/features/battery_status/cubit/battery_status_cubit.dart
import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:battery_plus/battery_plus.dart' as bp; // Alias para evitar conflicto
import 'package:equatable/equatable.dart';

part 'battery_state.dart'; // Referencia al archivo de estado

class BatteryCubit extends Cubit<BatteryState> {
  final bp.Battery _battery;
  StreamSubscription<bp.BatteryState>? _batteryStateSubscription;

  // Inyectamos la instancia de Battery
  BatteryCubit({required bp.Battery battery})
      : _battery = battery,
        super(BatteryInitial()) {
    _initialize(); // Iniciar la obtención y escucha
  }

  // Obtiene el estado inicial y comienza a escuchar
  Future<void> _initialize() async {
    // Emitir estado inicial mientras esperamos la primera lectura
    emit(BatteryInitial());
    // Obtener el estado y nivel inicial
    await _updateBatteryStatus();
    // Comenzar a escuchar cambios en el ESTADO de carga
    _listenToBatteryChanges();
  }

  // Escucha los cambios en el estado de carga desde el plugin
  void _listenToBatteryChanges() {
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((_) {
      // Cuando el *estado* de carga cambia (conectado/desconectado),
      // volvemos a obtener el nivel y estado actualizados.
      _updateBatteryStatus();
    });
  }

  // Método para obtener el nivel y estado actual y emitir el estado Loaded
  Future<void> _updateBatteryStatus() async {
    try {
      // Obtenemos ambos valores actuales desde el plugin
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      // Emitimos el estado con los datos cargados
      emit(BatteryLoaded(level, state));
    } catch (e) {
      // Manejo básico de errores (podrías emitir un estado BatteryStatusError)
      log("Error al obtener estado de batería: $e");
      // emit(BatteryStatusError("Error al obtener estado: $e"));
    }
  }

  // Es crucial cancelar la suscripción cuando el Cubit ya no se use
  @override
  Future<void> close() {
    _batteryStateSubscription?.cancel();
    return super.close();
  }
}