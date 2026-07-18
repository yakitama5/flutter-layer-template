// ignore_for_file: lines_longer_than_80_chars

import 'dart:math';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:domain/core.dart';
import 'package:domain/goods.dart';
import 'package:riverpod/riverpod.dart';

const _totalLength = 100;

const _images = [
  'https://placehold.jp/3d4070/ffffff/150x150.png?text=Example',
  'https://placehold.jp/703e65/ffffff/150x150.png?text=Example',
  'https://placehold.jp/6643b6/ffffff/150x150.png?text=Example',
  'https://placehold.jp/b6ad43/ffffff/150x150.png?text=Example',
  'https://placehold.jp/b65a43/ffffff/150x150.png?text=Example',
  'https://placehold.jp/43a9b6/ffffff/150x150.png?text=Example',
  'https://placehold.jp/43b65a/ffffff/150x150.png?text=Example',
];

const _descriptions = [
  'てへぺろ(・ω<)',
  'カチャカチャカチャ・・・ッターン！',
  'ﾒﾛｽゎ走った……ｾﾘﾇﾝﾃｨｳｽがまってる……でも……もぅつかれちゃった…でも……あきらめるのょくなぃって……ﾒﾛｽゎ……ぉもって……がんばった……でも……ﾈｲﾙ…われて……ｲﾀｲょ……ｺﾞﾒﾝ……まにあわなかった……でも……ﾒﾛｽとｾﾘﾇﾝゎ……ｽﾞｯ友だょ……!!',
  'ざわ…ざわ…',
  'チェンジワイパー☆∠(ﾟωﾟ)／',
  'こちらは、志布志市志布志町志布志の志布志市役所志布志支所です。',
  '注視していく。慎重に注視する。警戒感を持って注視。最大限の緊張感を持って注視する。適切に対応する。緊張感を持って対応する。警戒感を持って取り組む。慎重に見極める。慎重に検討する。検討するかどうかを検討する。最善の方法を検討する。検討に検討を重ねる。専門家の意見を伺いながら検討を続ける。あらゆる選択肢を排除しない。現実的に検討を加速する。',
  '昼飯のスパゲティナポリタンを眺めながら、積年の疑問を考えていた。それは「なぜナポリタンは赤いのだろうか」という問いである。簡単に見えて、奥の深い問題だ。「赤いから赤いのだ」などとトートロジーを並べて悦に入る浅薄な人間もいるが、それは思考停止に他ならず、知性の敗北以外なにものでもない。「赤方偏移」という現象がある。宇宙空間において、地球から高速に遠ざかる天体ほどドップラー効果により、そのスペクトル線が赤色の方に遷移するという現象である。つまり、本来のナポリタンが何色であろうとも、ナポリタンが我々から高速で遠ざかっているとすれば、毒々しく赤く見えるはずなのだ。目の前のナポリタンは高速で動いているか否か？それはナポリタンの反対側に回ってみることでわかる。運動の逆方向から観察することで、スペクトルは青方遷移し、青く見えるはずなのだ。逆に回ってみたところ、ナポリタンは赤かった。よってこのナポリタンは高速移動をしていないと言える。',
  '雨ってゅうのゎ。。９割以上が水分。。。そしてきゅうりも、９割以上が水分。。。そぅ。。これゎもぅ。。。雨＝きゅうりってゅうコト。。。空から降る一億のきゅうり。。。もぅﾏﾁﾞ無理。。。浅漬けにしょ。。。。',
  'こんばんは。エルマ族のケムチャといいます。エルマ族の中でも優秀な、ハスーイの末裔ですよ。この前、友達のクレセロとジャッフンーの大会に出たんです。それで決勝までいったんですが、決勝で凄い面白いことが起きたんですよ。なんと最終ババウのときに、クロセロがケウェーウをシャイツｗｗｗｗｗしかも相手チームもハジャエをロッキンスマールしてたしｗｗｗセルニャじゃないんだからｗｗｗｗまじうけるｗｗｗｗｗナハウｗｗｗハユイｗｗｗケスｗｗｗｗやべｗｗｗｗ母国語でちゃったｗｗｗバスｗｗｗｗ ',
  'それは仕様です。',
  'トゥットゥルー♪',
  '彼女からのメールに、「ごめん、お風呂入ってた。今、神と化してるから、終わったら電話するね」と書いてありました。彼女の正体は、一体何者なのでしょうか？',
  'あげぽよ～☆',
  '＿|＼○＿　ｲﾔｯ　ε＝　＼＿○ノ　ﾎｫｫｫｫｫｩ!!!!!!',
];

class MockGoodsRepository extends GoodsRepository {
  MockGoodsRepository(this.ref);

  final Ref ref;

  static final List<Goods> items = List.generate(_totalLength, (i) {
    return Goods(
      id: 'Id $i',
      name: 'Name $i',
      price: i * 100,
      imageUrl: _images[i % _images.length],
      description: _descriptions[i % _descriptions.length],
      createdAt: clock.fromNow(days: -i),
      updatedAt: clock.fromNow(days: -i),
    );
  });

  @override
  Stream<Goods?> listenGoods({required String id}) {
    // 該当なしの場合は`StateError`を投げる`firstWhere`ではなく、
    // `null`を返す`firstWhereOrNull`を使用する
    final item = items.firstWhereOrNull((e) => e.id == id);
    return Stream.value(item);
  }

  @override
  Stream<PageInfo<Goods>> listenGoodsList({
    int page = 1,
    int pageSize = goodsPageSize,
    required GoodsFetchQuery query,
  }) async* {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    final hoge = items
        .map((e) => e.copyWith(price: Random().nextInt(max(1, 100))))
        .toList();

    final sortItems = hoge.sorted(
      (a, b) => switch (query.sortKey) {
        GoodsSortKey.createdAt => a.createdAt.compareTo(b.createdAt),
        GoodsSortKey.name => a.name.compareTo(b.name),
        GoodsSortKey.price => a.price?.compareTo(b.price ?? 0) ?? 0,
      },
    );

    // https://github.com/dart-lang/sdk/issues/43763
    // HACK(yakitama5): Dart3.7で書き直す
    // final sortItems = switch (query.sortKey) {
    //   GoodsSortKey.createdAt => items.sortedBy((e) => e.createdAt),
    //   GoodsSortKey.name => items.sortedBy((e) => e.name),
    //   GoodsSortKey.price => items.sortedBy((e) => e.price ?? 0),
    // };

    final orderItems = switch (query.sortOrder) {
      SortOrder.asc => sortItems,
      SortOrder.desc => sortItems.reversed.toList(),
    };

    final start = (page - 1) * pageSize;
    final end = min(start + pageSize, items.length);
    final result = PageInfo<Goods>(
      items: orderItems.sublist(start, end),
      totalCount: items.length,
    );

    yield* Stream.value(result);
  }
}
