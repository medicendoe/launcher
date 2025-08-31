import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/app_config.dart';
import '../../domain/models/window_config.dart';
import '../../domain/models/shortcut_config.dart';
import '../bloc/config_cubit.dart';
import '../../../app_list/app_list_feature.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        actions: [
          BlocBuilder<ConfigCubit, ConfigState>(
            builder: (context, state) {
              return IconButton(
                icon: state.isSaving 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                onPressed: state.isSaving 
                    ? null 
                    : () => context.read<ConfigCubit>().saveConfig(),
              );
            },
          ),
        ],
      ),
      body: BlocListener<ConfigCubit, ConfigState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<ConfigCubit>().clearMessages();
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ConfigCubit>().clearMessages();
          }
        },
        child: BlocBuilder<ConfigCubit, ConfigState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Configuración de página de apps
                  _buildAppPageSection(context, state.config),
                  const SizedBox(height: 24),
                  
                  // Configuración de ventanas
                  ...state.config.windowConfigs.map(
                    (windowConfig) => Column(
                      children: [
                        _buildWindowSection(context, windowConfig),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  
                  // Botón para resetear
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _showResetDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Resetear a valores por defecto'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppPageSection(BuildContext context, AppConfig config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Página de Aplicaciones',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Atajos deslizables:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...config.appPageShortcuts.map(
              (shortcut) => _buildShortcutTile(
                context,
                shortcut,
                onChanged: (packageName) => context
                    .read<ConfigCubit>()
                    .updateAppPageShortcut(shortcut.direction, packageName),
                onRemove: () => context
                    .read<ConfigCubit>()
                    .removeAppPageShortcut(shortcut.direction),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showAddShortcutDialog(context, null),
              icon: const Icon(Icons.add),
              label: const Text('Agregar atajo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWindowSection(BuildContext context, WindowConfig windowConfig) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ventana ${windowConfig.type.name.toUpperCase()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Apps en la ventana
            Text(
              'Aplicaciones mostradas:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showSelectAppsDialog(context, windowConfig),
              icon: const Icon(Icons.apps),
              label: Text('Configurar apps (${windowConfig.appPackageNames.length})'),
            ),
            const SizedBox(height: 16),
            
            // Atajos de la ventana
            Text(
              'Atajos deslizables:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...windowConfig.shortcuts.map(
              (shortcut) => _buildShortcutTile(
                context,
                shortcut,
                onChanged: (packageName) => context
                    .read<ConfigCubit>()
                    .updateWindowShortcut(windowConfig.type, shortcut.direction, packageName),
                onRemove: () => context
                    .read<ConfigCubit>()
                    .removeWindowShortcut(windowConfig.type, shortcut.direction),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showAddShortcutDialog(context, windowConfig.type),
              icon: const Icon(Icons.add),
              label: const Text('Agregar atajo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutTile(
    BuildContext context,
    ShortcutConfig shortcut, {
    required Function(String) onChanged,
    required VoidCallback onRemove,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(_getDirectionIcon(shortcut.direction)),
        title: Text(_getDirectionName(shortcut.direction)),
        subtitle: Text(shortcut.packageName.isEmpty 
            ? 'Sin aplicación asignada' 
            : shortcut.packageName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showSelectAppDialog(context, onChanged),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDirectionIcon(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.up:
        return Icons.keyboard_arrow_up;
      case SwipeDirection.down:
        return Icons.keyboard_arrow_down;
      case SwipeDirection.left:
        return Icons.keyboard_arrow_left;
      case SwipeDirection.right:
        return Icons.keyboard_arrow_right;
    }
  }

  String _getDirectionName(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.up:
        return 'Deslizar hacia arriba';
      case SwipeDirection.down:
        return 'Deslizar hacia abajo';
      case SwipeDirection.left:
        return 'Deslizar hacia la izquierda';
      case SwipeDirection.right:
        return 'Deslizar hacia la derecha';
    }
  }

  void _showSelectAppsDialog(BuildContext context, WindowConfig windowConfig) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<ConfigCubit>(),
          child: _SelectAppsDialog(windowConfig: windowConfig),
        );
      },
    );
  }

  void _showSelectAppDialog(BuildContext context, Function(String) onSelected) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _SelectAppDialog(onSelected: onSelected);
      },
    );
  }

  void _showAddShortcutDialog(BuildContext context, WindowType? windowType) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<ConfigCubit>(),
          child: _AddShortcutDialog(windowType: windowType),
        );
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Resetear configuración'),
          content: const Text(
            '¿Estás seguro de que quieres resetear toda la configuración a los valores por defecto?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ConfigCubit>().resetToDefaults();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Resetear'),
            ),
          ],
        );
      },
    );
  }
}

class _SelectAppsDialog extends StatefulWidget {
  final WindowConfig windowConfig;

  const _SelectAppsDialog({required this.windowConfig});

  @override
  State<_SelectAppsDialog> createState() => _SelectAppsDialogState();
}

class _SelectAppsDialogState extends State<_SelectAppsDialog> {
  Set<String> selectedApps = {};
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedApps = Set.from(widget.windowConfig.appPackageNames);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            AppBar(
              title: Text('Seleccionar apps para ${widget.windowConfig.type.name}'),
              automaticallyImplyLeading: false,
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<ConfigCubit>().updateWindowApps(
                      widget.windowConfig.type,
                      selectedApps.toList(),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar aplicaciones...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<AppListCubit, AppListState>(
                builder: (context, state) {
                  var filteredApps = state.installedApps;
                  
                  if (searchQuery.isNotEmpty) {
                    filteredApps = filteredApps
                        .where((app) =>
                            app.name.toLowerCase().contains(searchQuery) ||
                            app.packageName.toLowerCase().contains(searchQuery))
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = filteredApps[index];
                      final isSelected = selectedApps.contains(app.packageName);

                      return CheckboxListTile(
                        title: Text(app.name),
                        subtitle: Text(app.packageName),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedApps.add(app.packageName);
                            } else {
                              selectedApps.remove(app.packageName);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectAppDialog extends StatefulWidget {
  final Function(String) onSelected;

  const _SelectAppDialog({required this.onSelected});

  @override
  State<_SelectAppDialog> createState() => _SelectAppDialogState();
}

class _SelectAppDialogState extends State<_SelectAppDialog> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            AppBar(
              title: const Text('Seleccionar aplicación'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar aplicaciones...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<AppListCubit, AppListState>(
                builder: (context, state) {
                  var filteredApps = state.installedApps;
                  
                  if (searchQuery.isNotEmpty) {
                    filteredApps = filteredApps
                        .where((app) =>
                            app.name.toLowerCase().contains(searchQuery) ||
                            app.packageName.toLowerCase().contains(searchQuery))
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = filteredApps[index];

                      return ListTile(
                        title: Text(app.name),
                        subtitle: Text(app.packageName),
                        onTap: () {
                          widget.onSelected(app.packageName);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddShortcutDialog extends StatefulWidget {
  final WindowType? windowType;

  const _AddShortcutDialog({this.windowType});

  @override
  State<_AddShortcutDialog> createState() => _AddShortcutDialogState();
}

class _AddShortcutDialogState extends State<_AddShortcutDialog> {
  SwipeDirection? selectedDirection;
  String selectedPackageName = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar atajo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<SwipeDirection>(
            decoration: const InputDecoration(labelText: 'Dirección'),
            value: selectedDirection,
            items: SwipeDirection.values.map((direction) {
              return DropdownMenuItem(
                value: direction,
                child: Text(_getDirectionName(direction)),
              );
            }).toList(),
            onChanged: (SwipeDirection? value) {
              setState(() {
                selectedDirection = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showSelectAppDialog(context, (packageName) {
              setState(() {
                selectedPackageName = packageName;
              });
            }),
            child: Text(selectedPackageName.isEmpty 
                ? 'Seleccionar aplicación' 
                : selectedPackageName),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: selectedDirection != null && selectedPackageName.isNotEmpty
              ? () {
                  if (widget.windowType != null) {
                    context.read<ConfigCubit>().updateWindowShortcut(
                      widget.windowType!,
                      selectedDirection!,
                      selectedPackageName,
                    );
                  } else {
                    context.read<ConfigCubit>().updateAppPageShortcut(
                      selectedDirection!,
                      selectedPackageName,
                    );
                  }
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Agregar'),
        ),
      ],
    );
  }

  String _getDirectionName(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.up:
        return 'Deslizar hacia arriba';
      case SwipeDirection.down:
        return 'Deslizar hacia abajo';
      case SwipeDirection.left:
        return 'Deslizar hacia la izquierda';
      case SwipeDirection.right:
        return 'Deslizar hacia la derecha';
    }
  }

  void _showSelectAppDialog(BuildContext context, Function(String) onSelected) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _SelectAppDialog(onSelected: onSelected);
      },
    );
  }
}
