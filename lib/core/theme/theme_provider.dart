import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

/// Theme mode enum for user preference
enum ThemeModePreference {
  light,
  dark,
  system,
}

/// Provider for theme management using Hive for persistence
class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = AppConstants.settingsBox;
  static const String _themeKey = 'theme_mode';

  Box? _box;
  ThemeModePreference _themeMode = ThemeModePreference.system;
  bool _isInitialized = false;

  ThemeModePreference get themeMode => _themeMode;
  bool get isDarkMode {
    if (_themeMode == ThemeModePreference.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeModePreference.dark;
  }

  bool get isInitialized => _isInitialized;

  /// Initialize theme from Hive before first frame
  Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      
      if (!Hive.isBoxOpen(_themeBoxName)) {
        _box = await Hive.openBox(_themeBoxName);
      } else {
        _box = Hive.box(_themeBoxName);
      }

      final savedTheme = _box?.get(_themeKey, defaultValue: ThemeModePreference.system.index);
      _themeMode = ThemeModePreference.values[savedTheme ?? 0];
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // Fallback to system default if Hive fails
      _themeMode = ThemeModePreference.system;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Set theme mode and persist to Hive
  Future<void> setThemeMode(ThemeModePreference mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await _box?.put(_themeKey, mode.index);
    notifyListeners();
  }

  /// Toggle between light and dark modes
  Future<void> toggleTheme() async {
    final newMode = isDarkMode 
        ? ThemeModePreference.light 
        : ThemeModePreference.dark;
    await setThemeMode(newMode);
  }

  /// Get the Material ThemeMode for MaterialApp
  MaterialTheme getMaterialThemeMode() {
    switch (_themeMode) {
      case ThemeModePreference.light:
        return MaterialTheme.light;
      case ThemeModePreference.dark:
        return MaterialTheme.dark;
      case ThemeModePreference.system:
        return MaterialTheme.system;
    }
  }
}
