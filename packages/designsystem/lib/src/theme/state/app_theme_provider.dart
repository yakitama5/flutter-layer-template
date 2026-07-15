import 'package:designsystem/extension.dart';
import 'package:designsystem/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import 'app_color_scheme_provider.dart';

/// アプリ内のテーマを管理
final appThemeProvider = Provider.autoDispose.family<ThemeData, Brightness>((
  ref,
  brightness,
) {
  final colorScheme = ref.watch(appColorSchemeProvider(brightness));
  final uiStyle = ref.watch(uiStyleProvider);

  return ThemeData(
    colorScheme: colorScheme,
    brightness: brightness,
    platform: uiStyle.platform,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        // https://github.com/flutter/flutter/issues/132504#issuecomment-2025776552
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    extensions: [AppColors.brightness(brightness: brightness)],
  );
});
