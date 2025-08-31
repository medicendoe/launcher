import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installed_apps/index.dart';
import '../bloc/app_list_cubit.dart';

class AppListWidget extends StatelessWidget {
  final List<String>? filter;
  final bool scrollEnabled;
  final String searchQuery;
  final VoidCallback? onRefresh;

  const AppListWidget({
    super.key, 
    this.filter, 
    this.scrollEnabled = true,
    this.searchQuery = '',
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppListCubit, AppListState>(
      builder: (context, state) {
        // Siempre mostrar apps disponibles, incluso si la lista está vacía
        var filteredApps = state.installedApps;

        // Apply package name filter if specified
        if (filter != null && filter!.isNotEmpty) {
          filteredApps = filteredApps
              .where((app) => filter!.contains(app.packageName))
              .toList();
        }

        // Apply search query filter if specified
        if (searchQuery.isNotEmpty) {
          filteredApps = filteredApps
              .where((app) => app.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();
        }

        // Si es la carga inicial y no hay apps, mostrar indicador de carga
        if (state.isInitialLoad && state.installedApps.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando aplicaciones...'),
              ],
            ),
          );
        }

        // Si no hay apps después de filtrar, mostrar mensaje apropiado
        if (filteredApps.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.installedApps.isEmpty 
                      ? 'No hay apps disponibles'
                      : searchQuery.isNotEmpty 
                          ? 'No hay apps que coincidan con "$searchQuery"'
                          : 'No hay apps disponibles con los filtros aplicados',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (state.isUpdating)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            _buildListView(context, filteredApps, state),
            // Indicador de actualización en segundo plano
            if (state.isUpdating && !state.isInitialLoad)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, List<AppInfo> filteredApps, AppListState state) {
    Widget listView = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          return false; // Permite que se propague al padre
        }
        return true;
      },
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: filteredApps.length,
          physics: scrollEnabled
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final app = filteredApps[index];
            return ListTile(
              title: Text(app.name, style: Theme.of(context).textTheme.bodyLarge),
              onTap: () => {
                InstalledApps.startApp(
                  app.packageName,
                ),
                Navigator.pop(context),
              },
            );
          },
        ),
      ),
    );

    // Si tenemos callback de refresh y scroll está habilitado, envolver en RefreshIndicator
    if (onRefresh != null && scrollEnabled) {
      return RefreshIndicator(
        onRefresh: () async {
          onRefresh!();
          // Esperar un poco para que se vea el indicador
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: listView,
      );
    }

    return listView;
  }
}
