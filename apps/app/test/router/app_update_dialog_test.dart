import 'package:designsystem/i18n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:flutter_app/src/app.dart';
import 'package:flutter_app/src/router/routes/base_shell_route.dart';
import 'package:flutter_app/src/router/state/initial_location_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infrastructure_mock/designsystem.dart';
import 'package:infrastructure_mock/goods.dart';
import 'package:infrastructure_mock/user.dart';
import 'package:packages_application/core.dart';
import 'package:packages_application/designsystem.dart';
import 'package:packages_application/goods.dart';
import 'package:packages_application/user.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:version/version.dart';

/// E2E(`integration_test/app_flow_test.dart`)の強制アップデート/メンテナンス
/// 分岐を、iOSビルド不要のWidgetテストとして高速に検証する。
AppBuildConfig _testAppBuildConfig() => AppBuildConfig(
  flavor: Flavor.dev,
  appName: 'Widget Test Template',
  packageName: 'com.example.widget.test',
  version: Version(1, 0, 0),
  buildNumber: '1',
  buildSignature: 'widget-test',
);

Future<void> _pumpMainApp(
  WidgetTester tester, {
  required List<Override> overrides,
}) async {
  LocaleSettings.setLocale(AppLocale.en);

  await tester.pumpWidget(
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
  await tester.pumpAndSettle();
}

List<Override> _overrides({
  AppMaintenanceStatus maintenanceStatus = AppMaintenanceStatus.none,
  AppUpdateStatus updateStatus = AppUpdateStatus.usingLatest,
}) => [
  userRepositoryProvider.overrideWithValue(FakeUserRepository()),
  appMaintenanceStatusProvider.overrideWith(
    (ref) => Stream.value(maintenanceStatus),
  ),
  appUpdateStatusProvider.overrideWith((ref) => updateStatus),
  themeRepositoryProvider.overrideWithValue(FakeThemeRepository()),
  goodsConfigRepositoryProvider.overrideWithValue(FakeGoodsConfigRepository()),
  goodsRepositoryProvider.overrideWithValue(FakeGoodsRepository()),
];

void main() {
  testWidgets('強制アップデート時にダイアログが表示されOKを押しても閉じない', (tester) async {
    await _pumpMainApp(
      tester,
      overrides: _overrides(updateStatus: AppUpdateStatus.updateRequired),
    );

    final forceUpdateMessage =
        designsystemI18n.designsystem.appUpdate.forceUpdate.message;
    final navigateStoreLabel =
        designsystemI18n.designsystem.appUpdate.navigateStore;

    expect(find.text(forceUpdateMessage), findsOneWidget);

    // OK(ストアへ移動)を押してもダイアログは閉じない(popOnOk: false)
    await tester.tap(find.text(navigateStoreLabel));
    await tester.pumpAndSettle();
    expect(find.text(forceUpdateMessage), findsOneWidget);
  });

  testWidgets('メンテナンスモード時にメンテナンス画面が表示される', (tester) async {
    await _pumpMainApp(
      tester,
      overrides: _overrides(maintenanceStatus: AppMaintenanceStatus.maintenance),
    );

    expect(find.text('Maintenance mode'), findsOneWidget);
    expect(find.text('Start'), findsNothing);
  });
}
