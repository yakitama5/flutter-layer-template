import 'dart:async';

import 'package:designsystem/src/extension/app_theme_mode_extension.dart';
import 'package:packages_application/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

/// テーマを管理するProvider
/// SharedPreferencesの同期を待たずにUIに反映するため、Notifierを利用している
final themeModeProvider =
    NotifierProvider.autoDispose<ThemeModeNotifier, ThemeMode>(
      ThemeModeNotifier.new,
    );

class ThemeModeNotifier extends Notifier<ThemeMode> {
  ThemeRepository get _repository => ref.watch(themeRepositoryProvider);

  @override
  ThemeMode build() =>
      _repository.fetchThemeMode()?.themeMode ?? AppThemeMode.system.themeMode;

  Future<void> update(ThemeMode themeMode) async {
    final appThemeMode = switch (themeMode) {
      ThemeMode.system => AppThemeMode.system,
      ThemeMode.light => AppThemeMode.light,
      ThemeMode.dark => AppThemeMode.dark,
    };

    // 設定反映を待たずに設定する
    unawaited(_repository.updateThemeMode(appThemeMode));
    state = themeMode;
  }
}
