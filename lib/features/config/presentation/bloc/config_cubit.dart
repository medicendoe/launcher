import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../config/domain/models/app_config.dart';
import '../../../config/domain/models/window_config.dart';
import '../../../config/domain/models/shortcut_config.dart';
import '../../data/config_repository.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  final ConfigRepository _repository;

  ConfigCubit(this._repository) : super(ConfigState.initial()) {
    loadConfig();
  }

  Future<void> loadConfig() async {
    emit(state.copyWith(isLoading: true));
    try {
      final config = await _repository.loadConfig();
      emit(state.copyWith(
        config: config,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Error cargando configuración: $e',
      ));
    }
  }

  Future<void> saveConfig() async {
    emit(state.copyWith(isSaving: true));
    try {
      await _repository.saveConfig(state.config);
      emit(state.copyWith(
        isSaving: false,
        successMessage: 'Configuración guardada',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        error: 'Error guardando configuración: $e',
      ));
    }
  }

  void updateWindowApps(WindowType windowType, List<String> packageNames) {
    final updatedConfigs = state.config.windowConfigs.map((config) {
      if (config.type == windowType) {
        return config.copyWith(appPackageNames: packageNames);
      }
      return config;
    }).toList();

    emit(state.copyWith(
      config: state.config.copyWith(windowConfigs: updatedConfigs),
    ));
  }

  void updateWindowShortcut(WindowType windowType, SwipeDirection direction, String packageName) {
    final updatedConfigs = state.config.windowConfigs.map((config) {
      if (config.type == windowType) {
        final updatedShortcuts = config.shortcuts.map((shortcut) {
          if (shortcut.direction == direction) {
            return shortcut.copyWith(packageName: packageName);
          }
          return shortcut;
        }).toList();

        // Si no existe el shortcut, agregarlo
        if (!updatedShortcuts.any((s) => s.direction == direction)) {
          updatedShortcuts.add(ShortcutConfig(
            direction: direction,
            packageName: packageName,
          ));
        }

        return config.copyWith(shortcuts: updatedShortcuts);
      }
      return config;
    }).toList();

    emit(state.copyWith(
      config: state.config.copyWith(windowConfigs: updatedConfigs),
    ));
  }

  void updateAppPageShortcut(SwipeDirection direction, String packageName) {
    final updatedShortcuts = state.config.appPageShortcuts.map((shortcut) {
      if (shortcut.direction == direction) {
        return shortcut.copyWith(packageName: packageName);
      }
      return shortcut;
    }).toList();

    // Si no existe el shortcut, agregarlo
    if (!updatedShortcuts.any((s) => s.direction == direction)) {
      updatedShortcuts.add(ShortcutConfig(
        direction: direction,
        packageName: packageName,
      ));
    }

    emit(state.copyWith(
      config: state.config.copyWith(appPageShortcuts: updatedShortcuts),
    ));
  }

  void removeWindowShortcut(WindowType windowType, SwipeDirection direction) {
    final updatedConfigs = state.config.windowConfigs.map((config) {
      if (config.type == windowType) {
        final updatedShortcuts = config.shortcuts
            .where((shortcut) => shortcut.direction != direction)
            .toList();
        return config.copyWith(shortcuts: updatedShortcuts);
      }
      return config;
    }).toList();

    emit(state.copyWith(
      config: state.config.copyWith(windowConfigs: updatedConfigs),
    ));
  }

  void removeAppPageShortcut(SwipeDirection direction) {
    final updatedShortcuts = state.config.appPageShortcuts
        .where((shortcut) => shortcut.direction != direction)
        .toList();

    emit(state.copyWith(
      config: state.config.copyWith(appPageShortcuts: updatedShortcuts),
    ));
  }

  void resetToDefaults() {
    emit(state.copyWith(config: AppConfig.initial()));
  }

  void clearMessages() {
    emit(state.copyWith(error: null, successMessage: null));
  }
}
