import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:designsystem/i18n/strings.g.dart';
import 'package:designsystem/src/components/src/dialogs.dart';
import 'package:designsystem/src/keys/root_navigator_key.dart';
import 'package:domain/util.dart';
import 'package:packages_application/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nested/nested.dart';
import 'package:store_redirect/store_redirect.dart';

class AppUpdateListener extends SingleChildStatelessWidget {
  const AppUpdateListener({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => Consumer(
    child: child,
    builder: (_, ref, child) {
      ref.listen(appUpdateStatusProvider, (_, snapshot) async {
        // 共通Widgetのため、呼び出し元によらずRootを利用する
        final rootContext = rootNavigatorKey.currentContext;
        if (!snapshot.hasValue || rootContext == null || !rootContext.mounted) {
          return;
        }

        final status = snapshot.value;
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
            return switch (result) {
              OkCancelResult.ok => navigateToStore(ref),
              OkCancelResult.cancel => null,
            };
          case AppUpdateStatus.usingLatest:
          case null:
          // do nothing
        }
      });

      return child ?? const SizedBox.shrink();
    },
  );

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
