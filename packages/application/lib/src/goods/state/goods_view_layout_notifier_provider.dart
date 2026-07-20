import 'dart:async';

import 'package:domain/designsystem.dart';
import 'package:domain/goods.dart';
import 'package:riverpod/riverpod.dart';

import '../interface/goods_config_repository.dart';

final goodsViewLayoutProvider =
    NotifierProvider.autoDispose<GoodsViewLayoutNotifier, ViewLayout>(
      GoodsViewLayoutNotifier.new,
    );

class GoodsViewLayoutNotifier extends Notifier<ViewLayout> {
  GoodsConfigRepository get _repository =>
      ref.watch(goodsConfigRepositoryProvider);

  @override
  ViewLayout build() {
    // 未設定の場合に備えて初期値を設定
    return _repository.fetchViewLayout() ?? ViewLayout.list;
  }

  Future<void> updateViewLayout({required ViewLayout viewLayout}) async {
    // 先に結果を返す
    state = viewLayout;

    // 非同期で処理を保存する
    unawaited(_repository.updateViewLayout(viewLayout: viewLayout));
  }
}
