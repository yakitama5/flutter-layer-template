import 'package:designsystem/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:flutter_app/src/settings/components/src/settings_radio_list_tile.dart';
import 'package:flutter_app/src/settings/pages/settings_theme_mode_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infrastructure_mock/designsystem.dart';
import 'package:packages_application/designsystem.dart';

/// `SettingsThemeModePage` 単体のWidgetテスト用Pump処理
///
/// ルーティングやMainApp全体を経由せず、`themeRepositoryProvider` を
/// `FakeThemeRepository` に差し替えたうえでページ単体をpumpする。
/// ページが依存するのは `themeModeProvider`(内部で`themeRepositoryProvider`を
/// watch)のみのため、E2E(`app_flow_test.dart`)よりも軽量に検証できる。
Future<void> _pumpSettingsThemeModePage(
  WidgetTester tester, {
  required FakeThemeRepository themeRepository,
}) async {
  LocaleSettings.setLocale(AppLocale.en);

  await tester.pumpWidget(
    TranslationProvider(
      child: DesignsystemTranslationProvider(
        child: ProviderScope(
          overrides: [
            themeRepositoryProvider.overrideWithValue(themeRepository),
          ],
          child: const MaterialApp(home: SettingsThemeModePage()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// 指定した選択肢(`Key('settings_theme_mode_option_*')`)のWidgetを取得する
SettingsRadioListTile<ThemeMode> _findOption(
  WidgetTester tester,
  ThemeMode themeMode,
) => tester.widget<SettingsRadioListTile<ThemeMode>>(
  find.byKey(Key('settings_theme_mode_option_${themeMode.name}')),
);

void main() {
  testWidgets('テーマ未設定の場合はシステムテーマが選択されている', (tester) async {
    await _pumpSettingsThemeModePage(
      tester,
      themeRepository: FakeThemeRepository(),
    );

    // FakeThemeRepositoryは未設定(null)のため、システムテーマがデフォルトになる
    expect(_findOption(tester, ThemeMode.system).groupValue, ThemeMode.system);
    expect(_findOption(tester, ThemeMode.light).groupValue, ThemeMode.system);
    expect(_findOption(tester, ThemeMode.dark).groupValue, ThemeMode.system);
  });

  testWidgets('保存済みのテーマ設定が初期選択状態に反映される', (tester) async {
    await _pumpSettingsThemeModePage(
      tester,
      themeRepository: FakeThemeRepository(initialThemeMode: AppThemeMode.dark),
    );

    // リポジトリに保存済みのダークテーマが選択状態になる
    expect(_findOption(tester, ThemeMode.dark).groupValue, ThemeMode.dark);
  });

  testWidgets('ライトテーマをタップすると選択状態が切り替わりリポジトリへ保存される', (tester) async {
    final themeRepository = FakeThemeRepository();
    await _pumpSettingsThemeModePage(tester, themeRepository: themeRepository);

    // タップ前はシステムテーマが選択されている
    expect(_findOption(tester, ThemeMode.light).groupValue, ThemeMode.system);

    // ライトテーマをタップすると選択状態が切り替わる
    await tester.tap(find.byKey(const Key('settings_theme_mode_option_light')));
    await tester.pumpAndSettle();
    expect(_findOption(tester, ThemeMode.light).groupValue, ThemeMode.light);

    // リポジトリにも保存される
    expect(themeRepository.fetchThemeMode(), AppThemeMode.light);
  });
}
