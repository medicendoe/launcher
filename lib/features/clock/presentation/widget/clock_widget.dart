import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/clock_cubit.dart';
import 'package:launcher/features/battery/battery_feature.dart';
import 'package:battery_plus/battery_plus.dart' as bp;

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> weekdayNames = [
      '', // No se usa el índice 0
      'Monday',    // 1
      'Tuesday',   // 2
      'Wednesday', // 3
      'Thursday',  // 4
      'Friday',    // 5
      'Saturday',  // 6
      'Sunday'     // 7
    ];

    return BlocBuilder<ClockCubit, ClockState>(
      builder: (context, state) {
        // Obtener el estado de la batería
        final batteryState = context.watch<BatteryCubit>().state;
        
        // Determinar el color según el estado de la batería
        Color clockColor = Colors.white; // Color por defecto
        
        if (batteryState is BatteryLoaded) {
          if (batteryState.chargingState == bp.BatteryState.charging) {
            clockColor = Color(0xFFCCFFCC);
          } else if (batteryState.level <= 15) {
            clockColor = Color(0xFFFFCCCB);
          } else if (batteryState.level <= 35) {
            clockColor = Color(0xFFFFDAB9);
          }
        }
        
        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${state.hour.toString().padLeft(2, '0')}:${state.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: clockColor),
              ),
              const SizedBox(height: 8),
              Text(
                '${state.day.toString().padLeft(2, '0')}/${state.month.toString().padLeft(2, '0')}/${state.year}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(color: clockColor),
              ),
              const SizedBox(height: 4),
              Text(
                weekdayNames[state.weekday],
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: clockColor),
              ),
            ],
          ),
        );
      },
    );
  }
}
