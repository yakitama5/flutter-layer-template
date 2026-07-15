// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_shell_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$baseShellRouteData];

RouteBase get $baseShellRouteData => ShellRouteData.$route(
  navigatorKey: BaseShellRouteData.$navigatorKey,
  factory: $BaseShellRouteDataExtension._fromState,
  routes: [
    GoRouteData.$route(path: '/', factory: $RootRouteData._fromState),
    GoRouteData.$route(path: '/onboard', factory: $OnboardRouteData._fromState),
    GoRouteData.$route(
      path: '/maintenance',
      factory: $MaintenancePageRouteData._fromState,
    ),
    StatefulShellRouteData.$route(
      factory: $NavigatorPageShellRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/home',
              factory: $HomePageRouteData._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/goods',
              factory: $GoodsPageRouteData._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/setting',
              factory: $SettingPageRouteData._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'account',
                  factory: $SettingsAccountPageRouteData._fromState,
                ),
                GoRouteData.$route(
                  path: 'ui_style',
                  factory: $SettingsUiStylePageRouteData._fromState,
                ),
                GoRouteData.$route(
                  path: 'color_style',
                  factory: $SettingsThemeColorPageRouteData._fromState,
                ),
                GoRouteData.$route(
                  path: 'theme_mode',
                  factory: $SettingsThemeModePageRouteData._fromState,
                ),
                GoRouteData.$route(
                  path: 'license',
                  factory: $LicensePageRouteData._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

extension $BaseShellRouteDataExtension on BaseShellRouteData {
  static BaseShellRouteData _fromState(GoRouterState state) =>
      BaseShellRouteData();
}

mixin $RootRouteData on GoRouteData {
  static RootRouteData _fromState(GoRouterState state) => const RootRouteData();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OnboardRouteData on GoRouteData {
  static OnboardRouteData _fromState(GoRouterState state) =>
      const OnboardRouteData();

  @override
  String get location => GoRouteData.$location('/onboard');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MaintenancePageRouteData on GoRouteData {
  static MaintenancePageRouteData _fromState(GoRouterState state) =>
      const MaintenancePageRouteData();

  @override
  String get location => GoRouteData.$location('/maintenance');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

extension $NavigatorPageShellRouteDataExtension on NavigatorPageShellRouteData {
  static NavigatorPageShellRouteData _fromState(GoRouterState state) =>
      const NavigatorPageShellRouteData();
}

mixin $HomePageRouteData on GoRouteData {
  static HomePageRouteData _fromState(GoRouterState state) =>
      const HomePageRouteData();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GoodsPageRouteData on GoRouteData {
  static GoodsPageRouteData _fromState(GoRouterState state) =>
      const GoodsPageRouteData();

  @override
  String get location => GoRouteData.$location('/goods');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingPageRouteData on GoRouteData {
  static SettingPageRouteData _fromState(GoRouterState state) =>
      const SettingPageRouteData();

  @override
  String get location => GoRouteData.$location('/setting');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsAccountPageRouteData on GoRouteData {
  static SettingsAccountPageRouteData _fromState(GoRouterState state) =>
      const SettingsAccountPageRouteData();

  @override
  String get location => GoRouteData.$location('/setting/account');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsUiStylePageRouteData on GoRouteData {
  static SettingsUiStylePageRouteData _fromState(GoRouterState state) =>
      const SettingsUiStylePageRouteData();

  @override
  String get location => GoRouteData.$location('/setting/ui_style');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsThemeColorPageRouteData on GoRouteData {
  static SettingsThemeColorPageRouteData _fromState(GoRouterState state) =>
      const SettingsThemeColorPageRouteData();

  @override
  String get location => GoRouteData.$location('/setting/color_style');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsThemeModePageRouteData on GoRouteData {
  static SettingsThemeModePageRouteData _fromState(GoRouterState state) =>
      const SettingsThemeModePageRouteData();

  @override
  String get location => GoRouteData.$location('/setting/theme_mode');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LicensePageRouteData on GoRouteData {
  static LicensePageRouteData _fromState(GoRouterState state) =>
      const LicensePageRouteData();

  @override
  String get location => GoRouteData.$location('/setting/license');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
