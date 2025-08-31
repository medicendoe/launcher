import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher/features/app_list/app_list_feature.dart';
import 'package:launcher/features/config/config_feature.dart';
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
    return BlocBuilder<ConfigCubit, ConfigState>(
      builder: (context, configState) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final config = configState.config;
            if (details.delta.dx > 0) {
              // Swipe hacia la derecha
              final rightShortcut = config.getShortcut(SwipeDirection.right);
              if (rightShortcut != null && rightShortcut.packageName.isNotEmpty) {
                InstalledApps.startApp(rightShortcut.packageName);
                Navigator.pop(context);
              }
            } else if (details.delta.dx < 0) {
              // Swipe hacia la izquierda
              final leftShortcut = config.getShortcut(SwipeDirection.left);
              if (leftShortcut != null && leftShortcut.packageName.isNotEmpty) {
                InstalledApps.startApp(leftShortcut.packageName);
                Navigator.pop(context);
              }
            }
          },
          child: NotificationListener<OverscrollNotification>(
            onNotification: (notification) {
              final config = configState.config;
              if (notification.overscroll > 0) {
                // Overscroll hacia abajo
                final downShortcut = config.getShortcut(SwipeDirection.down);
                if (downShortcut != null && downShortcut.packageName.isNotEmpty) {
                  InstalledApps.startApp(downShortcut.packageName);
                  Navigator.pop(context);
                }
              } else if (notification.overscroll < 0) {
                // Overscroll hacia arriba
                final upShortcut = config.getShortcut(SwipeDirection.up);
                if (upShortcut != null && upShortcut.packageName.isNotEmpty) {
                  InstalledApps.startApp(upShortcut.packageName);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              }
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => Navigator.pushNamed(context, '/config'),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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
      },
    );
  }
}