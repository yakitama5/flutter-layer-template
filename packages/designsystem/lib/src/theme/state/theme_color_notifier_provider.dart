import 'dart:async';

import 'package:designsystem/src/theme/model/dynamic_color_support_status.dart';
import 'package:packages_application/designsystem.dart';
import 'package:riverpod/riverpod.dart';

import 'dynamic_color_support_provider.dart';

/// テーマカラーを管理するProvider
/// SharedPreferencesの同期を待たずにUIに反映するため、Notifierを利用している
final themeColorProvider =
    NotifierProvider.autoDispose<ThemeColorNotifier, ThemeColor>(
      ThemeColorNotifier.new,
    );

class ThemeColorNotifier extends Notifier<ThemeColor> {
  ThemeRepository get _repository => ref.watch(themeRepositoryProvider);

  @override
  ThemeColor build() {
    final themeColor = _repository.fetchThemeColor();

    // 初期値は `DynamicColor`のサポート有無で変更
    final supportStatus = ref.watch(dynamicColorSupportProvider);
    final defaultValue = switch (supportStatus) {
      DynamicColorSupportStatus.supported => ThemeColor.dynamicColor,
      DynamicColorSupportStatus.notSupported => ThemeColor.appColor,
    };

    return themeColor ?? defaultValue;
  }

  Future<void> update(ThemeColor themeColor) async {
    // 設定反映を待たずに設定する
    unawaited(_repository.updateThemeColor(themeColor));
    state = themeColor;
  }
}
