import 'package:domain/core.dart';
import 'package:test/test.dart';

void main() {
  group('SortOrder', () {
    test('ascのreverseはdescを返す', () {
      expect(SortOrder.asc.reverse, SortOrder.desc);
    });

    test('descのreverseはascを返す', () {
      expect(SortOrder.desc.reverse, SortOrder.asc);
    });

    test('reverseを2回適用すると元に戻る', () {
      for (final order in SortOrder.values) {
        expect(order.reverse.reverse, order);
      }
    });
  });
}
