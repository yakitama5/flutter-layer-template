import 'package:designsystem/widgets.dart';
import 'package:domain/goods.dart';
import 'package:domain/util.dart';
import 'package:flutter/material.dart';

import '../components/goods_empty_image.dart';

class GoodsDetailPage extends StatelessWidget {
  const GoodsDetailPage({super.key, required this.goods});

  static const imageHeight = 480.0;
  static const duplicateHeight = 16.0;

  final Goods goods;

  @override
  Widget build(BuildContext context) {
    logger.d('Goods Detail: ${goods.id}');

    return Scaffold(
      // Body > AppBarの順で配置し、`LinkedScroll`で同期する
      body: LinkedScrollBuilder(
        builder: (context, controllerGroup, controllers) => Stack(
          children: [
            CustomScrollView(
              controller: controllers.one,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: imageHeight,
                  title: const Text('Linked Scroll Controller Group'),
                  flexibleSpace: FlexibleSpaceBar(
                    background: OverflowBox(
                      child: goods.imageUrl != null
                          ? Image.network(
                              goods.imageUrl!,
                              height: imageHeight,
                              fit: BoxFit.fitHeight,
                            )
                          : const GoodsEmptyImage(
                              width: double.infinity,
                              height: imageHeight,
                            ),
                    ),
                  ),
                ),
                const SliverFillRemaining(),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: CustomScrollView(
                  controller: controllers.two,
                  slivers: [
                    SliverPadding(
                      // AppBarとBodyに重なりを持たせて表示
                      padding: const EdgeInsets.only(
                        top: imageHeight - kToolbarHeight - duplicateHeight,
                      ),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) {
                          if (index <= 0) {
                            return const _FirstTile();
                          }
                          return ListTile(title: Text('Index $index'));
                        },
                        separatorBuilder: (_, _) => const Divider(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FirstTile extends StatelessWidget {
  const _FirstTile();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const SizedBox(height: 160, width: double.infinity),
    );
  }
}
