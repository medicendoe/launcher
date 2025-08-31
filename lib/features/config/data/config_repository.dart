import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/app_config.dart';

class ConfigRepository {
  static const String _configKey = 'app_config';

  Future<AppConfig> loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString(_configKey);
      
      if (configJson != null) {
        final configMap = jsonDecode(configJson) as Map<String, dynamic>;
        return AppConfig.fromJson(configMap);
      }
    } catch (e) {
      // Si hay error al cargar, retornar configuración inicial
      debugPrint('Error loading config: $e');
    }
    
    return AppConfig.initial();
  }

  Future<bool> saveConfig(AppConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = jsonEncode(config.toJson());
      return await prefs.setString(_configKey, configJson);
    } catch (e) {
      debugPrint('Error saving config: $e');
      return false;
    }
  }

  Future<bool> clearConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_configKey);
    } catch (e) {
      debugPrint('Error clearing config: $e');
      return false;
    }
  }
}
