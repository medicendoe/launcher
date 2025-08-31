import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher/features/app_list/app_list_feature.dart';
import 'package:installed_apps/installed_apps.dart';

class AppPageWidget extends StatefulWidget {
  const AppPageWidget({super.key});

  @override
  State<AppPageWidget> createState() => _AppPageWidgetState();
}

class _AppPageWidgetState extends State<AppPageWidget> {
  String searchQuery = '';
  
  void _refreshAppList() {
    // Obtener el cubit y refrescar la lista
    context.read<AppListCubit>().refreshAppList();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          // Swipe hacia la derecha
          InstalledApps.startApp('com.sec.android.app.popupcalculator');
          Navigator.pop(context);
        } else if (details.delta.dx < 0) {
          // Swipe hacia la izquierda
          InstalledApps.startApp('com.sec.android.app.myfiles');
          Navigator.pop(context);
        }
      },
      child: NotificationListener<OverscrollNotification>(
        onNotification: (notification) {
          if (notification.overscroll > 0) {
            // Overscroll hacia abajo
            InstalledApps.startApp('com.android.settings');
            Navigator.pop(context);
          } else if (notification.overscroll < 0) {
            // Overscroll hacia arriba
            Navigator.pop(context);
          }
          return true;
        },
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.filter_list),
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: AppListWidget(
                    searchQuery: searchQuery,
                    onRefresh: _refreshAppList,
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}