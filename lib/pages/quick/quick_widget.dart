import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:launcher/features/app_list/app_list_feature.dart';
import 'package:launcher/features/config/config_feature.dart';

class QuickPageWidget extends StatelessWidget {
  const QuickPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      builder: (context, configState) {
        final windowConfig = configState.config.getWindowConfig(WindowType.quick);
        final appList = windowConfig?.appPackageNames ?? [];

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 0) {
              // Swipe hacia la derecha
              final rightShortcut = windowConfig?.shortcuts
                  .where((s) => s.direction == SwipeDirection.right)
                  .firstOrNull;
              if (rightShortcut != null && rightShortcut.packageName.isNotEmpty) {
                InstalledApps.startApp(rightShortcut.packageName);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            } else if (details.delta.dx < 0) {
              // Swipe hacia la izquierda
              final leftShortcut = windowConfig?.shortcuts
                  .where((s) => s.direction == SwipeDirection.left)
                  .firstOrNull;
              if (leftShortcut != null && leftShortcut.packageName.isNotEmpty) {
                InstalledApps.startApp(leftShortcut.packageName);
                Navigator.pop(context);
              }
            }
          },
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 0) {
              // Swipe hacia abajo
              final downShortcut = windowConfig?.shortcuts
                  .where((s) => s.direction == SwipeDirection.down)
                  .firstOrNull;
              if (downShortcut != null && downShortcut.packageName.isNotEmpty) {
                InstalledApps.startApp(downShortcut.packageName);
                Navigator.pop(context);
              }
            } else if (details.delta.dy < 0) {
              // Swipe hacia arriba
              final upShortcut = windowConfig?.shortcuts
                  .where((s) => s.direction == SwipeDirection.up)
                  .firstOrNull;
              if (upShortcut != null && upShortcut.packageName.isNotEmpty) {
                InstalledApps.startApp(upShortcut.packageName);
                Navigator.pop(context);
              }
            }
          },
          child: Scaffold(
            body: Center(
              child: AppListWidget(filter: appList, scrollEnabled: false,)
            )
          ),
        );
      },
    );
  }
}