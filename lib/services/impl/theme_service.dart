import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:furious_app/services/service.dart';

class ThemeService extends Service {
  static const _kThemeModeKey = 'app.themeMode';
  final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);

  @override
  Future<void> init() async {
    await super.init();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kThemeModeKey);
    if (raw != null) {
      mode.value = ThemeMode.values.firstWhere(
            (m) => m.toString() == raw,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setMode(ThemeMode newMode) async {
    mode.value = newMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeModeKey, newMode.toString());
  }

  Future<void> toggle() async {
    final current = mode.value;
    if (current == ThemeMode.dark) {
      await setMode(ThemeMode.light);
    } else if (current == ThemeMode.light) {
      await setMode(ThemeMode.system);
    } else {
      await setMode(ThemeMode.dark);
    }
  }
}
