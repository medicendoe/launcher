import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importamos BlocProvider
import 'package:battery_plus/battery_plus.dart';
import 'package:launcher/features/clock/clock_feature.dart';
import 'package:launcher/features/battery/battery_feature.dart';
import 'package:launcher/app/route/route_constants.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final battery = Battery();

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          // Swipe hacia abajo
          Navigator.pushNamed(context, RouteConstants.chat);
        } else if (details.delta.dy < 0) {
          // Swipe hacia arriba
          Navigator.pushNamed(context, RouteConstants.app);
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          // Swipe hacia la derecha
          Navigator.pushNamed(context, RouteConstants.sport);
        } else if (details.delta.dx < 0) {
          // Swipe hacia la izquierda
          Navigator.pushNamed(context, RouteConstants.quick);
        }
      },
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ClockCubit>(
              create: (context) => ClockCubit(),
            ),
            BlocProvider<BatteryCubit>(
              create: (context) => BatteryCubit(battery: battery),
            ),
          ],
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClockWidget(),
              BatteryDisplayWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
