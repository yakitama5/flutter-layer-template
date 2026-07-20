import 'package:designsystem/widgets.dart';
import 'package:domain/designsystem.dart';
import 'package:packages_application/goods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/goods_card.dart';
import '../components/goods_list_tile.dart';
import '../components/goods_sort_key_chip.dart';
import 'goods_detail_page.dart';

class GoodsPage extends HookConsumerWidget {
  const GoodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 初期状態はドメイン層に定義
    final query = useState(const GoodsFetchQuery());
    final viewLayout = ref.watch(goodsViewLayoutProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(goodsUsecaseProvider).refreshGoods(query: query.value),
        // HACK(yakitama5): SliverAppBar付きのこの構成を共通定義化する
        child: CustomScrollView(
          slivers: [
            const PinnedHeaderSliver(
              child: Material(child: SafeArea(child: SizedBox.shrink())),
            ),
            SliverAppBar(
              primary: false,
              title: Text(i18n.goods.goodsPage.title),
            ),
            PinnedHeaderSliver(
              child: Material(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                  child: Row(
                    children: [
                      GoodsSortKeyChip(
                        onChanged: (sortKey) {
                          // 再選択の場合は順序を入れ替える
                          final isReselect = sortKey == query.value.sortKey;
                          query.value = isReselect
                              ? query.value.copyWith(
                                  sortOrder: query.value.sortOrder.reverse,
                                )
                              : GoodsFetchQuery(sortKey: sortKey);
                        },
                        sortKey: query.value.sortKey,
                        sortOrder: query.value.sortOrder,
                      ),
                      const Gap(12),
                      ViewLayoutChip(
                        viewLayout: viewLayout,
                        onChanged: (v) => ref
                            .read(goodsViewLayoutProvider.notifier)
                            .updateViewLayout(viewLayout: v),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _SliverBody(query: query.value, viewLayout: viewLayout),
          ],
        ),
      ),
    );
  }
}

class _SliverBody extends HookConsumerWidget {
  const _SliverBody({required this.query, required this.viewLayout});

  final GoodsFetchQuery query;
  final ViewLayout viewLayout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 先頭ページを固定で取得
    // エラーハンドリングはコンテンツ取得部分で行うため`valueOrNull`で無視する
    final result = ref.watch(goodsListProvider((page: 1, query: query))).value;

    return SliverSwitchLayoutViewBuilder(
      viewLayout: viewLayout,
      itemCount: result?.totalCount ?? goodsPageSize,
      itemBuilder: (context, index) {
        final page = index ~/ goodsPageSize + 1;
        final indexInPage = index % goodsPageSize;
        final response = ref.watch(
          goodsListProvider((page: page, query: query)),
        );

        return response.when(
          data: (data) {
            // 最終ページの件数が`goodsPageSize`未満の場合、
            // `indexInPage`が範囲外になり得るためガードする
            if (indexInPage >= data.items.length) {
              return const SizedBox.shrink();
            }

            return OpenContainerCardWrapper(
              openBuilder: (context, action) =>
                  GoodsDetailPage(goods: data.items[indexInPage]),
              closedBuilder: (context, action) {
                final item = data.items[indexInPage];
                return switch (viewLayout) {
                  ViewLayout.grid => GoodsCard(
                    key: ValueKey(item),
                    item: item,
                    onTap: action,
                  ),
                  ViewLayout.list => GoodsListTile(
                    key: ValueKey(item),
                    item: item,
                    onTap: action,
                  ),
                };
              },
            );
          },
          loading: () => _ShimmerTile(viewLayout: viewLayout),
          // TODO(yakitama5): エラー表示を分けて記載
          error: (error, _) => ErrorListTile(
            indexInPage: indexInPage,
            isLoading: response.isLoading,
            error: error.toString(),
            onRetry: () {
              ref.invalidate(goodsListProvider((page: page, query: query)));
            },
          ),
        );
      },
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile({required this.viewLayout});

  final ViewLayout viewLayout;

  @override
  Widget build(BuildContext context) {
    return switch (viewLayout) {
      ViewLayout.list => const _ShimmerListTile(),
      ViewLayout.grid => const ShimmerWidget.rectangular(height: 60),
    };
  }
}

class _ShimmerListTile extends StatelessWidget {
  const _ShimmerListTile();

  @override
  Widget build(BuildContext context) {
    // プライベートWidgetのためマジックナンバーを許容
    return const ListTile(
      title: ShimmerWidget.rectangular(height: 24),
      subtitle: ShimmerWidget.rectangular(height: 16),
      leading: GoodsShimmerListTileLeading(),
    );
  }
}
