import 'package:riverpod/riverpod.dart';

import 'package:domain/util.dart';

/// アプリ全体で共通するローディング表示を管理
///
/// `state`は同時に実行中の`wrap`呼び出し数を表すカウンタであり、
/// ローディング中かどうかは`state > 0`で判定する。
/// インスタンスフィールドでカウントを保持すると`autoDispose`による
/// 再生成時にカウントが消失するため、`state`自体にカウントを持たせている。
final appLoadingProvider = NotifierProvider.autoDispose<LoadingNotifier, int>(
  LoadingNotifier.new,
);

class LoadingNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  Future<T> wrap<T>(Future<T> future) async {
    state = state + 1;
    try {
      return await future;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    } finally {
      state = state - 1;
    }
  }
}
