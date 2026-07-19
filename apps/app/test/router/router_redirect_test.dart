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

/// テスト用の `AppBuildConfig`
///
/// Widgetテストでは `packageName` を参照する処理を通らないため、
/// tool/replace_app_id.dart の置換対象(integration_test)とは異なり
/// ダミー値を利用する。
AppBuildConfig _testAppBuildConfig() => AppBuildConfig(
  flavor: Flavor.dev,
  appName: 'Widget Test Template',
  packageName: 'com.example.widget.test',
  version: Version(1, 0, 0),
  buildNumber: '1',
  buildSignature: 'widget-test',
);

/// 共通のPump処理
///
/// E2E(`integration_test/app_flow_test.dart`)と同様に、
/// TranslationProvider〜MainAppまでのラップを共通化し、シナリオごとに
/// 必要なoverridesだけを差し替えられるようにする。
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

/// 標準シナリオ用のoverrides
///
/// メンテナンス・強制アップデートいずれも発生しない状態にし、
/// 認証状態のみ引数の `userRepository` で差し替えられるようにする。
List<Override> _defaultOverrides({required UserRepository userRepository}) => [
  userRepositoryProvider.overrideWithValue(userRepository),
  appMaintenanceStatusProvider.overrideWith(
    (ref) => Stream.value(AppMaintenanceStatus.none),
  ),
  appUpdateStatusProvider.overrideWith((ref) => AppUpdateStatus.usingLatest),
  themeRepositoryProvider.overrideWithValue(FakeThemeRepository()),
  goodsConfigRepositoryProvider.overrideWithValue(FakeGoodsConfigRepository()),
  goodsRepositoryProvider.overrideWithValue(FakeGoodsRepository()),
];

void main() {
  testWidgets('未認証状態で起動するとオンボーディング画面が表示される', (tester) async {
    await _pumpMainApp(
      tester,
      overrides: _defaultOverrides(userRepository: FakeUserRepository()),
    );

    // オンボーディング画面の「Start」ボタンが表示され、ホーム画面には遷移しない
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Hello Home!'), findsNothing);
  });

  testWidgets('認証済み状態で起動するとホーム画面にリダイレクトされる', (tester) async {
    await _pumpMainApp(
      tester,
      overrides: _defaultOverrides(
        userRepository: FakeUserRepository(
          initialAuthStatus: const AuthStatus(
            uid: 'widget-test-user',
            isAnonymous: false,
            linkedGoogle: false,
            linkedApple: false,
          ),
        ),
      ),
    );

    // オンボーディング画面をスキップし、ホーム画面が表示される
    expect(find.text('Hello Home!'), findsOneWidget);
    expect(find.text('Start'), findsNothing);
  });

  testWidgets('オンボーディング画面でStartをタップするとホーム画面へ遷移する', (tester) async {
    await _pumpMainApp(
      tester,
      overrides: _defaultOverrides(userRepository: FakeUserRepository()),
    );

    // 未認証のためオンボーディング画面から開始する
    expect(find.text('Start'), findsOneWidget);

    // Startをタップするとサインアップされ、ホーム画面へリダイレクトされる
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('Hello Home!'), findsOneWidget);
    expect(find.text('Start'), findsNothing);
  });
}
