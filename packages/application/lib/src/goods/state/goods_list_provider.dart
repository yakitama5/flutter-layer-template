import 'package:domain/core.dart';
import 'package:domain/goods.dart';
import 'package:domain/util.dart';
import 'package:packages_foundation/extension.dart';
import 'package:riverpod/riverpod.dart';

import '../interface/goods_repository.dart';

typedef GoodsListQuery = ({int page, GoodsFetchQuery query});

final goodsListProvider = StreamProvider.autoDispose
    .family<PageInfo<Goods>, GoodsListQuery>((ref, args) {
      // ページング利用のため、参照されなくなってから30秒間はキャッシュを保持する
      logger.d('GoodsListProvider: ${args.page}');
      ref.cacheFor(const Duration(seconds: 30));

      return ref
          .watch(goodsRepositoryProvider)
          .listenGoodsList(page: args.page, query: args.query);
    });
