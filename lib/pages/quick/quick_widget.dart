import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:launcher/features/app_list/app_list_feature.dart';

class QuickPageWidget extends StatelessWidget {
  const QuickPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> appList = [
      'notion.id',
      'cl.uchile.ing.adi.ucursos',
      'bbl.intl.bambulab.com',
      'net.veritran.becl.prod',
      'cl.bancochile.mi_banco',
      'cl.bancochile.mi_pass',
      'com.google.android.apps.docs'
    ];

    return GestureDetector(
    onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          // Swipe hacia la derecha
          Navigator.pop(context);
        } else if (details.delta.dx < 0) {
          // Swipe hacia la izquierda
          InstalledApps.startApp('com.android.chrome');
          Navigator.pop(context);
        }
    },
    onVerticalDragUpdate: (details) {
      if (details.delta.dy > 0) {
        // Swipe hacia abajo
        InstalledApps.startApp('com.google.android.calendar');
        Navigator.pop(context);
      } else if (details.delta.dy < 0) {
        // Swipe hacia arriba
        InstalledApps.startApp('com.spotify.music');
        Navigator.pop(context);
      }
    },
    child: Scaffold(
        body: Center(
          child: AppListWidget(filter: appList, scrollEnabled: false,)
        )
      ),
    );
  }
}