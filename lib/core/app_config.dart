import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class AppConfig {
  static const String keyBackendUrl = 'backend_base_url';
  static const String keyIsOfflineMode = 'is_offline_mode';
  static const String keySelectedLanguage = 'selected_language';

  static const String dbName = 'jeevsarthi_offline.db';
  static const int dbVersion = 1;

  /// Default backend URL targeting friend's local Node.js + Express backend
  static String get defaultBackendUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    try {
      if (Platform.isAndroid) {
        // Android emulator connects to host machine via 10.0.2.2
        return 'http://10.0.2.2:3000';
      }
    } catch (_) {}
    return 'http://localhost:3000';
  }

  static String _backendUrl = '';
  static bool _isOfflineDemoMode = false;
  static String _selectedLanguage = 'English';

  static String get backendUrl {
    if (_backendUrl.isEmpty) {
      return defaultBackendUrl;
    }
    return _backendUrl;
  }

  static bool get isOfflineDemoMode => _isOfflineDemoMode;
  static String get selectedLanguage => _selectedLanguage;

  static Future<void> loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _backendUrl = prefs.getString(keyBackendUrl) ?? defaultBackendUrl;
      _isOfflineDemoMode = prefs.getBool(keyIsOfflineMode) ?? false;
      _selectedLanguage = prefs.getString(keySelectedLanguage) ?? 'English';
    } catch (e) {
      debugPrint('Error loading AppConfig: $e');
    }
  }

  static Future<void> setSelectedLanguage(String language) async {
    _selectedLanguage = language;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keySelectedLanguage, language);
    } catch (_) {}
  }

  static Future<void> setBackendUrl(String url) async {
    _backendUrl = url;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keyBackendUrl, url);
    } catch (_) {}
  }

  static Future<void> setOfflineDemoMode(bool offline) async {
    _isOfflineDemoMode = offline;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyIsOfflineMode, offline);
    } catch (_) {}
  }
}

