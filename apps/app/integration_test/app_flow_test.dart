import 'dart:async';

import 'package:designsystem/i18n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:flutter_app/src/app.dart';
import 'package:flutter_app/src/router/routes/base_shell_route.dart';
import 'package:flutter_app/src/router/state/initial_location_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:packages_application/core.dart';
import 'package:packages_application/designsystem.dart';
import 'package:packages_application/goods.dart';
import 'package:packages_application/user.dart';
import 'package:patrol/patrol.dart';
import 'package:version/version.dart';

void main() {
  patrolTest('オンボーディングから主要画面を操作できる', ($) async {
    LocaleSettings.setLocale(AppLocale.en);
    final userRepository = _FakeUserRepository();

    await $.pumpWidgetAndSettle(
      TranslationProvider(
        child: DesignsystemTranslationProvider(
          child: ProviderScope(
            overrides: [
              appBuildConfigProvider.overrideWithValue(
                AppBuildConfig(
                  flavor: Flavor.dev,
                  appName: 'E2E Template',
                  packageName: 'com.yakuran.template.dev',
                  version: Version(1, 0, 0),
                  buildNumber: '1',
                  buildSignature: 'e2e',
                ),
              ),
              initialLocationProvider.overrideWithValue(RootRouteData.path),
              userRepositoryProvider.overrideWithValue(userRepository),
              appMaintenanceStatusProvider.overrideWith(
                (ref) => Stream.value(AppMaintenanceStatus.none),
              ),
              appUpdateStatusProvider.overrideWith(
                (ref) => AppUpdateStatus.usingLatest,
              ),
              themeRepositoryProvider.overrideWithValue(_FakeThemeRepository()),
              goodsConfigRepositoryProvider.overrideWithValue(
                _FakeGoodsConfigRepository(),
              ),
              goodsRepositoryProvider.overrideWithValue(_FakeGoodsRepository()),
            ],
            child: const MainApp(),
          ),
        ),
      ),
    );

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

    await $('ThemeMode').tap();
    await $.pumpAndSettle();
    expect($('ThemeMode'), findsWidgets);
  });
}

final class _FakeUserRepository implements UserRepository {
  final _authStatus = StreamController<AuthStatus?>.broadcast();

  @override
  Stream<AuthStatus?> listenAuthStatus() async* {
    yield null;
    yield* _authStatus.stream;
  }

  @override
  Future<void> signUp() async => _authStatus.add(const AuthStatus(
    uid: 'e2e-user',
    isAnonymous: true,
    linkedGoogle: false,
    linkedApple: false,
  ));

  @override
  Stream<User?> listen({required String userId}) => Stream.value(null);

  @override
  Future<void> delete({required String userId}) async {}
  @override
  Future<AuthStatus> signInAnonymously() => throw UnimplementedError();
  @override
  Future<AuthStatus> signInWithApple() => throw UnimplementedError();
  @override
  Future<AuthStatus> signInWithGoogle() => throw UnimplementedError();
  @override
  Future<void> signOut() async {}
  @override
  Future<void> unlinkWithApple() async {}
  @override
  Future<void> unlinkWithGoogle() async {}
}

final class _FakeThemeRepository implements ThemeRepository {
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

final class _FakeGoodsConfigRepository implements GoodsConfigRepository {
  ViewLayout? _layout;

  @override
  ViewLayout? fetchViewLayout() => _layout;
  @override
  Future<void> updateViewLayout({required ViewLayout viewLayout}) async =>
      _layout = viewLayout;
}

final class _FakeGoodsRepository implements GoodsRepository {
  @override
  Stream<Goods?> listenGoods({required String id}) => Stream.value(null);

  @override
  Stream<PageInfo<Goods>> listenGoodsList({
    int page = 1,
    int pageSize = goodsPageSize,
    required GoodsFetchQuery query,
  }) => Stream.value(const PageInfo(items: [], totalCount: 0));
}
