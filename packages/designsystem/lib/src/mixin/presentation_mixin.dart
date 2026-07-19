import 'package:designsystem/src/components/src/snack_bar_manager.dart';
import 'package:packages_application/core.dart';
import 'package:flutter/foundation.dart';

/// プレゼンテーション層用の共通処理 Mixin
mixin PresentationMixin {
  /// エラーハンドリングをラップした実行処理
  Future<void> execute({
    required AsyncCallback action,
    String? successMessage,
  }) async {
    try {
      await action();
      if (successMessage != null) {
        SnackBarManager.showInfoSnackBar(successMessage);
      }
    } on CancelledByUserException {
      // ユーザー操作によるキャンセルは通知不要
    } on AppException catch (e) {
      // TODO(yakitama5): 例外種別に応じたi18nメッセージへの変換
      SnackBarManager.showErrorSnackBar(e.message ?? '');
    } on Exception catch (e) {
      SnackBarManager.showErrorSnackBar(e.toString());
    }
  }
}
