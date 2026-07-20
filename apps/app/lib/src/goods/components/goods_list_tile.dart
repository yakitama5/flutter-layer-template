import 'package:designsystem/widgets.dart';
import 'package:domain/goods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/i18n/strings.g.dart';

import 'goods_empty_image.dart';

class GoodsListTile extends StatelessWidget {
  const GoodsListTile({super.key, required this.item, this.onTap});

  final Goods item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(item.name),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: item.imageUrl == null
            ? const GoodsEmptyImage(width: 64, height: 64)
            : Image.network(
                item.imageUrl!,
                width: 64,
                height: 64,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                    ? child
                    : const GoodsShimmerListTileLeading(),
              ),
      ),
      subtitle: Text(i18n.goods.goodsPage.price(price: item.price ?? 0)),
    );
  }
}

class GoodsShimmerListTileLeading extends StatelessWidget {
  const GoodsShimmerListTileLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerWidget.rectangular(height: 64, width: 64);
  }
}
