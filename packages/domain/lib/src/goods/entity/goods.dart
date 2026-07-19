import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods.freezed.dart';

@freezed
abstract class Goods with _$Goods {
  const factory Goods({
    required String id,
    required String name,
    int? price,
    String? imageUrl,
    required String description,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Goods;
}
