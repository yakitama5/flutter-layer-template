import 'package:domain/designsystem.dart';
import 'package:flutter/material.dart';

extension AppThemeModeX on AppThemeMode {
  ThemeMode get themeMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}
