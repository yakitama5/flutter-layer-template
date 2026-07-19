import 'dart:async';

import 'package:packages_application/core.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('LoadingNotifier.wrap', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      // autoDispose対策: 購読を維持してstateの破棄を防ぐ
      container.listen(appLoadingProvider, (_, _) {});
    });

    tearDown(() {
      container.dispose();
    });

    test('wrap実行中はstateが1になり、完了後に0へ戻る', () async {
      final completer = Completer<void>();
      final future = container
          .read(appLoadingProvider.notifier)
          .wrap(completer.future);

      // wrap実行中はローディング中(state > 0)
      expect(container.read(appLoadingProvider), 1);

      completer.complete();
      await future;

      // 完了後はローディング解除(state == 0)
      expect(container.read(appLoadingProvider), 0);
    });

    test('並行してwrapした場合はカウントが呼び出し数分増減する', () async {
      final completer1 = Completer<void>();
      final completer2 = Completer<void>();
      final notifier = container.read(appLoadingProvider.notifier);

      final future1 = notifier.wrap(completer1.future);
      final future2 = notifier.wrap(completer2.future);

      // 2つ実行中はカウントが2
      expect(container.read(appLoadingProvider), 2);

      completer1.complete();
      await future1;

      // 片方だけ完了するとカウントは1
      expect(container.read(appLoadingProvider), 1);

      completer2.complete();
      await future2;

      // 全て完了するとカウントは0
      expect(container.read(appLoadingProvider), 0);
    });

    test('wrapしたFutureが例外をthrowしてもカウントはデクリメントされる', () async {
      final notifier = container.read(appLoadingProvider.notifier);

      // 例外は再送出される
      await expectLater(
        notifier.wrap(Future<void>.error(Exception('test error'))),
        throwsA(isA<Exception>()),
      );

      // 例外発生後もカウントは0へ戻る
      expect(container.read(appLoadingProvider), 0);
    });

    test('wrapはFutureの結果をそのまま返す', () async {
      final notifier = container.read(appLoadingProvider.notifier);

      final result = await notifier.wrap(Future.value(42));

      expect(result, 42);
    });
  });
}
