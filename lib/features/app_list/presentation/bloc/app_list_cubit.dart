import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

part 'app_list_state.dart';

class AppListCubit extends Cubit<AppListState> {
  Timer? _timer;
  static List<AppInfo>? _cachedApps; // Caché estático persistente
  static DateTime? _lastUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 30);
  bool _isCurrentlyUpdating = false;

  AppListCubit() : super(AppListState.initial()) {
    _initializeAndLoadApps();
    _startPeriodicUpdate();
  }

  Future<void> _initializeAndLoadApps() async {
    // Si tenemos caché disponible, mostrarlo inmediatamente
    if (_cachedApps != null && _cachedApps!.isNotEmpty) {
      emit(state.copyWith(
        installedApps: _cachedApps!,
        isInitialLoad: false,
        isUpdating: false,
      ));
      
      // Si el caché no es válido, actualizar en segundo plano
      if (!_isCacheValid()) {
        await _updateAppListInBackground();
      }
    } else {
      // Primera carga: mostrar indicador de carga inicial
      emit(state.copyWith(isUpdating: true, isInitialLoad: true));
      await _updateAppList();
    }
  }

  bool _isCacheValid() {
    if (_lastUpdate == null) return false;
    return DateTime.now().difference(_lastUpdate!) < _cacheValidDuration;
  }

  Future<void> _updateAppListInBackground() async {
    if (_isCurrentlyUpdating) return; // Evitar múltiples actualizaciones simultáneas
    
    _isCurrentlyUpdating = true;
    
    // Indicar que estamos actualizando (solo si no es carga inicial)
    if (!state.isInitialLoad) {
      emit(state.copyWith(isUpdating: true));
    }
    
    try {
      final apps = await InstalledApps.getInstalledApps(false, true);
      
      // Actualizar caché estático
      _cachedApps = apps;
      _lastUpdate = DateTime.now();
      
      // Emitir nuevo estado con apps actualizadas
      emit(state.copyWith(
        installedApps: apps,
        isUpdating: false,
        isInitialLoad: false,
      ));
    } catch (e) {
      // Si falla la actualización, mantener caché anterior y quitar indicador de carga
      emit(state.copyWith(
        isUpdating: false,
        isInitialLoad: false,
      ));
      // El error se maneja silenciosamente para no interrumpir la experiencia del usuario
    } finally {
      _isCurrentlyUpdating = false;
    }
  }

  Future<void> _updateAppList() async {
    await _updateAppListInBackground();
  }

  // Método público para forzar actualización manual
  Future<void> refreshAppList() async {
    await _updateAppListInBackground();
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(const Duration(minutes: 30), (_) {
      _updateAppListInBackground();
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}