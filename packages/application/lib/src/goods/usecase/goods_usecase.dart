import 'package:domain/goods.dart';
import 'package:riverpod/riverpod.dart';

import '../state/goods_list_provider.dart';

final goodsUsecaseProvider = Provider.autoDispose<GoodsUsecase>(
  GoodsUsecase.new,
);

class GoodsUsecase {
  const GoodsUsecase(this.ref);

  final Ref ref;

  /// 商品一覧を再読み込みする.
  Future<void> refreshGoods({required GoodsFetchQuery query}) async {
    // すべての要素を再読み込み
    ref.invalidate(goodsListProvider);

    // 最初のページが表示されるまでは待機
    return ref.read(goodsListProvider((page: 1, query: query)).future);
  }
}
