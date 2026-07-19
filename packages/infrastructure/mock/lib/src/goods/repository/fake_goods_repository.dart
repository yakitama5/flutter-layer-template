import 'package:domain/core.dart';
import 'package:domain/goods.dart';

/// E2E・Widgetテストなどで決定的に振る舞う `GoodsRepository` のFake実装
///
/// 常に空のリストを返す。データ件数に依存しない画面遷移・操作の検証に使う。
/// 実データを模したレスポンスが必要な場合は [MockGoodsRepository] を使う。
final class FakeGoodsRepository implements GoodsRepository {
  @override
  Stream<Goods?> listenGoods({required String id}) => Stream.value(null);

  @override
  Stream<PageInfo<Goods>> listenGoodsList({
    int page = 1,
    int pageSize = goodsPageSize,
    required GoodsFetchQuery query,
  }) => Stream.value(const PageInfo(items: [], totalCount: 0));
}
