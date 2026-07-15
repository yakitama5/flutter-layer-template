import 'package:packages_application/core.dart';
import 'package:packages_application/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/router/routes/base_shell_route.dart';
import 'package:flutter_app/src/router/routes/branches/home_shell_branch.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

final routerProvider = AsyncNotifierProvider.autoDispose<RouterNotifier, void>(
  RouterNotifier.new,
);

class RouterNotifier extends AsyncNotifier<void> implements Listenable {
  VoidCallback? _routerListener;

  @override
  Future<void> build() async {
    listenSelf((previous, next) {
      if (state.isLoading) {
        return;
      }

      _routerListener?.call();
    });
  }

  Future<String?> redirect(GoRouterState routeState) async {
    if (state.isLoading || state.hasError) {
      return null;
    }
    final location = routeState.fullPath ?? '';
    final isSplash = location == const RootRouteData().location;
    final isNotAuthLocations = location.startsWith(
      const OnboardRouteData().location,
    );

    // 認証判定
    final authUser = await ref.watch(authStatusProvider.future);
    if (authUser == null && (isSplash || !isNotAuthLocations)) {
      return const OnboardRouteData().location;
    } else if (authUser != null && (isSplash || isNotAuthLocations)) {
      return const HomePageRouteData().location;
    }

    // メンテナンスモード
    final appMaintenanceStatus = ref.watch(appMaintenanceStatusProvider).value;
    switch (appMaintenanceStatus) {
      case AppMaintenanceStatus.maintenance:
        return MaintenancePageRouteData.path;
      case AppMaintenanceStatus.none:
      case null:
        // メンテナンスページにいる場合は元に戻してやる
        if (location == MaintenancePageRouteData.path) {
          return HomePageRouteData.path;
        }
    }

    return null;
  }

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}
