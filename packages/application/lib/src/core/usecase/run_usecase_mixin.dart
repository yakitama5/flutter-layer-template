import 'package:riverpod/riverpod.dart';

import '../state/app_loading_provider.dart';

/// ユースケース実行時の共通処理を提供する。
mixin RunUsecaseMixin {
  Future<T> execute<T>(
    Ref ref, {
    required Future<T> Function() action,
    bool disableLoading = false,
  }) async {
    if (disableLoading) {
      return action();
    }

    return ref.read(appLoadingProvider.notifier).wrap(action());
  }
}
