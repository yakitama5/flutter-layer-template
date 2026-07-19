import 'package:domain/src/designsystem/value_object/app_theme_mode.dart';
import 'package:domain/src/designsystem/value_object/theme_color.dart';
import 'package:domain/src/designsystem/value_object/ui_style.dart';

abstract class ThemeRepository {
  UIStyle? fetchUIStyle();
  Future<void> updateUIStyle(UIStyle uiStyle);

  ThemeColor? fetchThemeColor();
  Future<void> updateThemeColor(ThemeColor themeColor);

  AppThemeMode? fetchThemeMode();
  Future<void> updateThemeMode(AppThemeMode themeMode);
}
