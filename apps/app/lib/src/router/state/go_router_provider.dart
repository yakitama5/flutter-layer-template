import 'package:flutter/foundation.dart';
import 'package:flutter_app/src/router/routes/base_shell_route.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

import 'initial_location_provider.dart';
import 'router_notifier_provider.dart';

final goRouterProvider = Provider.autoDispose<GoRouter>((ref) {
  final notifier = ref.watch(routerProvider.notifier);
  final initialLocation = ref.watch(initialLocationProvider);

  final router = GoRouter(
    routes: $appRoutes,
    debugLogDiagnostics: kDebugMode,
    initialLocation: initialLocation,

    // GoRouterそのものが再生成されないように、redirectは外部のNotifierに定義
    // ログイン状態やデータの変更でredirectを検知するように、`refreshListenable`を設定
    redirect: (_, routeState) => notifier.redirect(routeState),
    refreshListenable: notifier,
  );
  ref.onDispose(router.dispose);
  return router;
});
