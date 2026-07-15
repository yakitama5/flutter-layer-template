import 'dart:async';

import 'package:packages_application/designsystem.dart';
import 'package:riverpod/riverpod.dart';

/// UIスタイルを管理するProvider
/// SharedPreferencesの同期を待たずにUIに反映するため、Notifierを利用している
final uiStyleProvider = NotifierProvider.autoDispose<UiStyle, UIStyle>(
  UiStyle.new,
);

class UiStyle extends Notifier<UIStyle> {
  ThemeRepository get _repository => ref.watch(themeRepositoryProvider);

  @override
  UIStyle build() {
    final uiStyle = _repository.fetchUIStyle();

    // 初期値は「システム設定」
    return uiStyle ?? UIStyle.system;
  }

  Future<void> update(UIStyle uiStyle) async {
    // 設定反映を待たずに設定する
    unawaited(_repository.updateUIStyle(uiStyle));
    state = uiStyle;
  }
}
