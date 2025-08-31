import 'package:flutter/material.dart';
import 'package:launcher/features/app_list/app_list_feature.dart';
import 'package:installed_apps/installed_apps.dart';

class SportPageWidget extends StatelessWidget {
  const SportPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> appList = [
      'com.strava',
    ];

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          // Swipe hacia la derecha
          InstalledApps.startApp('com.google.android.apps.maps');
          Navigator.pop(context);
        } else if (details.delta.dx < 0) {
          // Swipe hacia la izquierda
          Navigator.pop(context);
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          // Swipe hacia abajo
          InstalledApps.startApp('com.garmin.android.apps.connectmobile');
          Navigator.pop(context);
        } else if (details.delta.dy < 0) {
          // Swipe hacia arriba
          InstalledApps.startApp('com.peaksware.trainingpeaks');
          Navigator.pop(context);
        }
      },
      child: Scaffold(
          body: Center(
            child: AppListWidget(filter: appList, scrollEnabled: false),
          )
        ),
    );
  }
}