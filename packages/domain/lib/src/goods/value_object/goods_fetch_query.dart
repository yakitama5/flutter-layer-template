import 'package:domain/src/core/value_object/sort_order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'goods_sort_key.dart';

part 'goods_fetch_query.freezed.dart';

// TODO(yakitama5): 共通化したい
@freezed
abstract class GoodsFetchQuery with _$GoodsFetchQuery {
  const factory GoodsFetchQuery({
    @Default(GoodsSortKey.price) GoodsSortKey sortKey,
    @Default(SortOrder.asc) SortOrder sortOrder,
  }) = _GoodsFetchQuery;
}
