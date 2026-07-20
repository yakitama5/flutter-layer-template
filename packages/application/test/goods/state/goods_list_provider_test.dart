import 'package:packages_application/core.dart';
import 'package:packages_application/goods.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

/// テスト用の最小fakeリポジトリ
///
/// applicationは中間層であり、依存方向を保つため
/// `packages/infrastructure/mock`（infrastructure層）へは依存させない。
/// そのためテストファイル内に最小限のfakeを定義する。
class _FakeGoodsRepository implements GoodsRepository {
  _FakeGoodsRepository(this.pageInfo);

  final PageInfo<Goods> pageInfo;

  /// 最後に要求されたページ番号(検証用)
  int? requestedPage;

  @override
  Stream<PageInfo<Goods>> listenGoodsList({
    int page = 1,
    int pageSize = goodsPageSize,
    required GoodsFetchQuery query,
  }) {
    requestedPage = page;
    return Stream.value(pageInfo);
  }

  @override
  Stream<Goods?> listenGoods({required String id}) => Stream.value(null);
}

void main() {
  group('goodsListProvider', () {
    test('overrideしたリポジトリが返すPageInfoを取得できる', () async {
      final goods = Goods(
        id: 'goods-1',
        name: 'テスト商品',
        price: 1000,
        description: 'テスト用の商品',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 2),
      );
      final repository = _FakeGoodsRepository(
        PageInfo(items: [goods], totalCount: 1),
      );
      final container = ProviderContainer(
        overrides: [goodsRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      const query = (page: 1, query: GoodsFetchQuery());
      // autoDispose対策: 購読を維持してローディング中の破棄を防ぐ
      container.listen(goodsListProvider(query), (_, _) {});
      final result = await container.read(goodsListProvider(query).future);

      expect(result.items, [goods]);
      expect(result.totalCount, 1);
      // リポジトリへ要求したページ番号が引き継がれること
      expect(repository.requestedPage, 1);
    });

    test('ページ番号がリポジトリへ引き継がれる', () async {
      final repository = _FakeGoodsRepository(
        const PageInfo(items: [], totalCount: 0),
      );
      final container = ProviderContainer(
        overrides: [goodsRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      const query = (page: 3, query: GoodsFetchQuery());
      // autoDispose対策: 購読を維持してローディング中の破棄を防ぐ
      container.listen(goodsListProvider(query), (_, _) {});
      final result = await container.read(goodsListProvider(query).future);

      expect(result.items, isEmpty);
      expect(repository.requestedPage, 3);
    });
  });
}
