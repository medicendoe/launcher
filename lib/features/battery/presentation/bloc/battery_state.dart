part of "battery_cubit.dart";

abstract class BatteryState extends Equatable {
  const BatteryState();

  @override
  List<Object> get props => [];
}

class BatteryInitial extends BatteryState {}

class BatteryLoaded extends BatteryState {
  final int level;                     // Nivel de 0 a 100
  final bp.BatteryState chargingState; // Estado de carga (usamos el tipo de battery_plus)

  const BatteryLoaded(this.level, this.chargingState);

  @override
  List<Object> get props => [level, chargingState]; // Propiedades a comparar
}
