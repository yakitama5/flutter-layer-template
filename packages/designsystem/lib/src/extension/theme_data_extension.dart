import 'package:flutter/material.dart';

import '../theme/theme_extensions/theme_extensions.dart';

extension ThemeDataX on ThemeData {
  AppColors get appColors => extension<AppColors>()!;

  /// iOS or Macか否か
  bool get isCupertinoPlatform {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        return true;
    }
  }
}
