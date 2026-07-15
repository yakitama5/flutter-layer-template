import 'package:designsystem/widgets.dart';
import 'package:domain/goods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:gap/gap.dart';

import 'goods_empty_image.dart';

class GoodsCard extends StatelessWidget {
  const GoodsCard({super.key, required this.item, this.onTap});

  final Goods item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return OutlinedCard(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _Image(
              imageUrl: item.imageUrl,
              semanticLabel: item.description,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 16,
                end: 16,
                top: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: tt.titleLarge),
                  const Gap(4),
                  Text(
                    i18n.goods.goodsPage.price(price: item.price ?? 0),
                    style: tt.titleMedium,
                  ),
                  const Gap(8),
                  Text(
                    item.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({required this.imageUrl, required this.semanticLabel});

  static const _imageHeight = 120.0;

  final String? imageUrl;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    // 画像指定無しの場合はダミー表示
    if (imageUrl?.isEmpty ?? true) {
      return const GoodsEmptyImage(
        height: _imageHeight,
        width: double.infinity,
      );
    }

    return Image.network(
      imageUrl!,
      height: _imageHeight,
      width: double.infinity,
      fit: BoxFit.fitWidth,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null
          ? child
          : const ShimmerWidget.rectangular(height: _imageHeight),
    );
  }
}
