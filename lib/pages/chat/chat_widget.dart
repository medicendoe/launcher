import 'package:flutter/material.dart';
import 'package:launcher/features/app_list/app_list_feature.dart';
import 'package:installed_apps/installed_apps.dart';

class ChatPageWidget extends StatelessWidget {
  const ChatPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> appList = [
      'com.whatsapp',
      'com.Slack',
      'org.telegram.messenger',
      'com.discord',
      'com.instagram.android',
      'com.bumble.app',
      'enterprises.dating.boo',
      'com.google.android.gm',
    ];

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          // Swipe hacia abajo
          InstalledApps.startApp('com.sec.android.app.camera');
          Navigator.pop(context);
        } else if (details.delta.dy < 0) {
          // Swipe hacia arriba
          Navigator.pop(context);
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          // Swipe hacia la derecha
          InstalledApps.startApp('com.samsung.android.dialer');
          Navigator.pop(context);
        } else if (details.delta.dx < 0) {
          // Swipe hacia la izquierda
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