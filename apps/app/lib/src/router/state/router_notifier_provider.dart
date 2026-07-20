import 'package:packages_application/core.dart';
import 'package:packages_application/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/router/routes/base_shell_route.dart';
import 'package:flutter_app/src/router/routes/branches/home_shell_branch.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

/// リダイレクト判定に必要な状態
typedef RouterRedirectState = ({
  AuthStatus? authStatus,
  AppMaintenanceStatus? maintenanceStatus,
});

final routerProvider =
    AsyncNotifierProvider.autoDispose<RouterNotifier, RouterRedirectState>(
      RouterNotifier.new,
    );

class RouterNotifier extends AsyncNotifier<RouterRedirectState>
    implements Listenable {
  VoidCallback? _routerListener;

  @override
  Future<RouterRedirectState> build() async {
    listenSelf((previous, next) {
      if (state.isLoading) {
        return;
      }

      _routerListener?.call();
    });

    // redirect()はbuild外(GoRouterからの非buildコンテキスト)で呼ばれるため、
    // リダイレクト判定に必要な値はここでwatchしてstateに保持しておく
    final authStatus = await ref.watch(authStatusProvider.future);
    final maintenanceStatus = ref.watch(appMaintenanceStatusProvider).value;

    return (authStatus: authStatus, maintenanceStatus: maintenanceStatus);
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

    // メンテナンスモードは認証状態に依らず全ユーザーをブロックするため、
    // 認証判定よりも先に評価する。
    final appMaintenanceStatus = state.value?.maintenanceStatus;
    if (appMaintenanceStatus == AppMaintenanceStatus.maintenance) {
      return location == MaintenancePageRouteData.path
          ? null
          : MaintenancePageRouteData.path;
    }

    // 認証判定
    final authUser = state.value?.authStatus;
    if (authUser == null && (isSplash || !isNotAuthLocations)) {
      return const OnboardRouteData().location;
    } else if (authUser != null && (isSplash || isNotAuthLocations)) {
      return const HomePageRouteData().location;
    }

    // メンテナンス解除後、メンテナンスページに留まっている場合は元に戻してやる
    if (location == MaintenancePageRouteData.path) {
      return HomePageRouteData.path;
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
