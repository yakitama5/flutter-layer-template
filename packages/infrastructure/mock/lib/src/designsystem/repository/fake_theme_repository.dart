import 'package:domain/designsystem.dart';

/// E2E・Widgetテストなどで決定的に振る舞う `ThemeRepository` のFake実装
///
/// [initialThemeMode] / [initialThemeColor] / [initialUIStyle] で
/// 初期状態を調整できる。デフォルトは全て未設定(`null`)から開始する。
final class FakeThemeRepository implements ThemeRepository {
  FakeThemeRepository({
    AppThemeMode? initialThemeMode,
    ThemeColor? initialThemeColor,
    UIStyle? initialUIStyle,
  }) : _themeMode = initialThemeMode,
       _themeColor = initialThemeColor,
       _uiStyle = initialUIStyle;

  AppThemeMode? _themeMode;
  ThemeColor? _themeColor;
  UIStyle? _uiStyle;

  @override
  AppThemeMode? fetchThemeMode() => _themeMode;
  @override
  ThemeColor? fetchThemeColor() => _themeColor;
  @override
  UIStyle? fetchUIStyle() => _uiStyle;
  @override
  Future<void> updateThemeMode(AppThemeMode themeMode) async =>
      _themeMode = themeMode;
  @override
  Future<void> updateThemeColor(ThemeColor themeColor) async =>
      _themeColor = themeColor;
  @override
  Future<void> updateUIStyle(UIStyle uiStyle) async => _uiStyle = uiStyle;
}
