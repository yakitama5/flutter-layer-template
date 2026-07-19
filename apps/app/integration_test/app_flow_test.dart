import 'package:designsystem/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:flutter_app/src/app.dart';
import 'package:flutter_app/src/router/routes/base_shell_route.dart';
import 'package:flutter_app/src/router/state/initial_location_provider.dart';
import 'package:flutter_app/src/settings/components/src/settings_radio_list_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infrastructure_mock/designsystem.dart';
import 'package:infrastructure_mock/goods.dart';
import 'package:infrastructure_mock/user.dart';
import 'package:packages_application/core.dart';
import 'package:packages_application/designsystem.dart';
import 'package:packages_application/goods.dart';
import 'package:packages_application/user.dart';
import 'package:patrol/patrol.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:version/version.dart';

/// テスト用の `AppBuildConfig`
///
/// packageNameの値は tool/replace_app_id.dart の置換対象文字列
/// (`packageName: '<値>'`)と暗黙的に結合している。書式を変更する場合は
/// 同ツールの置換ロジックとあわせて確認すること。
AppBuildConfig _testAppBuildConfig() => AppBuildConfig(
  flavor: Flavor.dev,
  appName: 'E2E Template',
  packageName: 'com.yakuran.template.dev',
  version: Version(1, 0, 0),
  buildNumber: '1',
  buildSignature: 'e2e',
);

/// 共通のPump処理
///
/// TranslationProvider〜MainAppまでのラップを共通化し、シナリオごとに
/// 必要なoverridesだけを差し替えられるようにする。
Future<void> pumpMainApp(
  PatrolIntegrationTester $, {
  required List<Override> overrides,
}) async {
  LocaleSettings.setLocale(AppLocale.en);

  await $.pumpWidgetAndSettle(
    TranslationProvider(
      child: DesignsystemTranslationProvider(
        child: ProviderScope(
          overrides: [
            appBuildConfigProvider.overrideWithValue(_testAppBuildConfig()),
            initialLocationProvider.overrideWithValue(RootRouteData.path),
            ...overrides,
          ],
          child: const MainApp(),
        ),
      ),
    ),
  );
}

/// 標準シナリオ用のoverrides
///
/// 未認証から開始し、メンテナンス・強制アップデートいずれも発生しない
/// 状態にする。
List<Override> _defaultOverrides({UserRepository? userRepository}) => [
  userRepositoryProvider.overrideWithValue(
    userRepository ?? FakeUserRepository(),
  ),
  appMaintenanceStatusProvider.overrideWith(
    (ref) => Stream.value(AppMaintenanceStatus.none),
  ),
  appUpdateStatusProvider.overrideWith((ref) => AppUpdateStatus.usingLatest),
  themeRepositoryProvider.overrideWithValue(FakeThemeRepository()),
  goodsConfigRepositoryProvider.overrideWithValue(FakeGoodsConfigRepository()),
  goodsRepositoryProvider.overrideWithValue(FakeGoodsRepository()),
];

void main() {
  patrolTest('オンボーディングから主要画面を操作できる', ($) async {
    await pumpMainApp($, overrides: _defaultOverrides());

    expect($('Start'), findsOneWidget);
    await $('Start').tap();
    await $.pumpAndSettle();
    expect($('Hello Home!'), findsOneWidget);

    await $('Search').tap();
    await $.pumpAndSettle();
    expect($('Goods'), findsOneWidget);

    await $('Settings').tap();
    await $.pumpAndSettle();
    expect($('UI Style'), findsOneWidget);

    // タップ前の状態: システムテーマが選択されている
    await $(#settings_theme_mode_tile).tap();
    await $.pumpAndSettle();

    // タップ後: テーマ選択画面に遷移し、システムテーマの選択肢が選択状態であること
    final systemTile = $.tester.widget<SettingsRadioListTile<ThemeMode>>(
      find.byKey(const Key('settings_theme_mode_option_system')),
    );
    expect(systemTile.groupValue, ThemeMode.system);

    // ライトテーマを選択すると、選択状態が切り替わること
    await $(#settings_theme_mode_option_light).tap();
    await $.pumpAndSettle();
    final lightTile = $.tester.widget<SettingsRadioListTile<ThemeMode>>(
      find.byKey(const Key('settings_theme_mode_option_light')),
    );
    expect(lightTile.groupValue, ThemeMode.light);
  });

  patrolTest('メンテナンスモード時にメンテナンス画面が表示される', ($) async {
    await pumpMainApp(
      $,
      overrides: [
        ..._defaultOverrides(),
        appMaintenanceStatusProvider.overrideWith(
          (ref) => Stream.value(AppMaintenanceStatus.maintenance),
        ),
      ],
    );

    expect($('Maintenance mode'), findsOneWidget);
    expect($('Maintenance in progress.\n\n\n'), findsOneWidget);
    // 通常画面には遷移しない
    expect($('Start'), findsNothing);
  });

  patrolTest('強制アップデート時にダイアログが表示されOKを押しても閉じない', ($) async {
    await pumpMainApp(
      $,
      overrides: [
        ..._defaultOverrides(),
        appUpdateStatusProvider.overrideWith(
          (ref) => AppUpdateStatus.updateRequired,
        ),
      ],
    );

    final forceUpdateMessage =
        designsystemI18n.designsystem.appUpdate.forceUpdate.message;
    final navigateStoreLabel =
        designsystemI18n.designsystem.appUpdate.navigateStore;

    expect($(forceUpdateMessage), findsOneWidget);

    // OK(ストアへ移動)ボタンを押してもダイアログは閉じない(popOnOk: false)
    await $(navigateStoreLabel).tap();
    await $.pumpAndSettle();
    expect($(forceUpdateMessage), findsOneWidget);
  });
}
