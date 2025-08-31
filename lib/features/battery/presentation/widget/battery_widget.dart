import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installed_apps/installed_apps.dart';
import '../bloc/battery_cubit.dart';
import 'package:battery_plus/battery_plus.dart' as bp; // Alias
import 'arc_painter.dart'; // Importamos el ArcPainter

class BatteryDisplayWidget extends StatelessWidget {
  final Widget? child;

  const BatteryDisplayWidget({ super.key, this.child});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder reconstruye la UI cuando el estado del Cubit cambia
    return BlocBuilder<BatteryCubit, BatteryState>(
      builder: (context, state) {
        if (state is BatteryInitial) {
          // Muestra un indicador mientras se carga el estado inicial
          return Center(child: CircularProgressIndicator());
        } else if (state is BatteryLoaded) {
          // Muestra la información de la batería cuando está cargada
          return _buildBatteryArc(context, state.level, state.chargingState);
        } else {
          // Estado por defecto o inesperado
          return Center(child: Text('Estado desconocido'));
        }
      },
    );
  }

  // Widget auxiliar para construir la UI con el ArcPainter
  Widget _buildBatteryArc(BuildContext context, int level, bp.BatteryState chargingState) {
    Color arcColor;

    // Determinar el color del arco según el nivel de batería
    if (chargingState == bp.BatteryState.charging) {
      arcColor = Color(0xFFCCFFCC);
    } else if (level <= 15) {
      arcColor = Color(0xFFFFCCCB);
    } else if (level <= 35) {
      arcColor = Color(0xFFFFDAB9);
    } else {
      arcColor = Colors.white;
    }

    // Obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;
    final double canvasSize = size.width < size.height ? size.width : size.height;
    final double margin = 10.0;

    return GestureDetector(
      onTap: () async {
        InstalledApps.startApp(
          'com.sec.android.app.clockpackage',
        );
      },
      child: ClipOval(
        child: SizedBox(
          width: canvasSize - margin * 2, // Tamaño dinámico con margen
          height: canvasSize - margin * 2, // Tamaño dinámico con margen
          child: CustomPaint(
            painter: ArcPainter(
              percentage: level,
              foregroundColor: arcColor,
              strokeWidth: 10.0,
            ),
          ),
        ),
      ),
    );
  }
}