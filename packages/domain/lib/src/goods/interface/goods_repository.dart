import 'package:domain/core.dart';

import '../constants/goods_constants.dart';
import '../entity/goods.dart';
import '../value_object/goods_fetch_query.dart';

abstract class GoodsRepository {
  Stream<PageInfo<Goods>> listenGoodsList({
    int page = 1,
    int pageSize = goodsPageSize,
    required GoodsFetchQuery query,
  });

  Stream<Goods?> listenGoods({required String id});
}
