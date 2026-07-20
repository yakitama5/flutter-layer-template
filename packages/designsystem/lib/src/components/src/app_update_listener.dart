import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:designsystem/i18n/strings.g.dart';
import 'package:designsystem/src/components/src/dialogs.dart';
import 'package:designsystem/src/keys/root_navigator_key.dart';
import 'package:domain/util.dart';
import 'package:packages_application/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nested/nested.dart';
import 'package:store_redirect/store_redirect.dart';

class AppUpdateListener extends SingleChildStatelessWidget {
  const AppUpdateListener({super.key, super.child});

  /// [rootNavigatorKey] が mount されるまでダイアログ表示を待つ最大フレーム数。
  ///
  /// fireImmediately の初回発火は rootNavigator の mount より前に起き得るため、
  /// mount 完了までフレーム単位でリトライする。無限ループを避ける安全弁。
  static const _maxReadyRetry = 60;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => HookConsumer(
    child: child,
    builder: (_, ref, child) {
      useEffect(() {
        // WidgetRef.listen は登録時点で解決済みの値を通知しないため、
        // listenManual + fireImmediately で購読開始時の値も確実に処理する。
        // これにより、初回起動時に既に updateRequired が解決している場合や、
        // 同期的にoverrideするテストでも強制アップデート判定が発火する。
        final subscription = ref.listenManual(
          appUpdateStatusProvider,
          (_, snapshot) {
            if (!snapshot.hasValue) {
              return;
            }
            _showDialogWhenReady(ref, snapshot.value);
          },
          fireImmediately: true,
        );

        return subscription.close;
      }, const []);

      return child ?? const SizedBox.shrink();
    },
  );

  /// rootNavigator が利用可能になってからステータスに応じたダイアログを表示する。
  ///
  /// fireImmediately の初回発火時は rootNavigator がまだ mount されていない
  /// 場合があるため、mount されるまで次フレームでリトライする。
  void _showDialogWhenReady(WidgetRef ref, AppUpdateStatus? status, [
    int attempt = 0,
  ]) {
    // ダイアログ不要なステータスでは rootNavigator の mount を待たない
    // (happy pathで無駄にフレームを進めない)
    switch (status) {
      case AppUpdateStatus.usingLatest:
      case null:
        return;
      case AppUpdateStatus.updateRequired:
      case AppUpdateStatus.updatePossible:
        break;
    }

    // 共通Widgetのため、呼び出し元によらずRootを利用する
    final rootContext = rootNavigatorKey.currentContext;
    if (rootContext == null || !rootContext.mounted) {
      if (attempt >= _maxReadyRetry) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showDialogWhenReady(ref, status, attempt + 1),
      );
      // pumpAndSettle 等、次フレームが自発的に来ない環境でも確実にリトライする
      SchedulerBinding.instance.scheduleFrame();
      return;
    }

    _showDialog(ref, rootContext, status);
  }

  Future<void> _showDialog(
    WidgetRef ref,
    BuildContext rootContext,
    AppUpdateStatus? status,
  ) async {
    switch (status) {
      case AppUpdateStatus.updateRequired:
        await showOkBarrierDismissibleDialog(
          rootContext,
          message: i18n.designsystem.appUpdate.forceUpdate.message,
          okLabel: i18n.designsystem.appUpdate.navigateStore,
          // 強制アップデートはストア遷移が完了するまでダイアログを閉じさせない
          popOnOk: false,
          onOk: () => navigateToStore(ref),
        );
      case AppUpdateStatus.updatePossible:
        final result = await showOkCancelAlertDialog(
          context: rootContext,
          message: i18n.designsystem.appUpdate.updatePossible.message,
          okLabel: i18n.designsystem.appUpdate.navigateStore,
        );
        switch (result) {
          case OkCancelResult.ok:
            await navigateToStore(ref);
          case OkCancelResult.cancel:
            break;
        }
      case AppUpdateStatus.usingLatest:
      case null:
      // do nothing
    }
  }

  /// ストアページへ遷移する.
  Future<void> navigateToStore(WidgetRef ref) async {
    final appBuildConfig = ref.read(appBuildConfigProvider);

    // TODO(yakitama5): テンプレート利用者は、App Store Connectで発行される
    // 数値のApp Store ID(bundle IDではない)を flavor/*.json の appStoreId に設定すること。
    final appStoreId = appBuildConfig.appStoreId;
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        (appStoreId == null || appStoreId.isEmpty)) {
      // appStoreId未設定のままbundle IDを渡すとiOSではストア遷移が成立しないため、
      // ここで早期returnする。Androidはbundle ID(packageName)で遷移可能なため影響しない。
      logger.w('appStoreIdが未設定のため、iOSのストア遷移をスキップします。');
      return;
    }

    return StoreRedirect.redirect(
      androidAppId: appBuildConfig.packageName,
      iOSAppId: appStoreId,
    );
  }
}
