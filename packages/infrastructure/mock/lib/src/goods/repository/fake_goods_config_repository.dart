import 'package:domain/designsystem.dart';
import 'package:domain/goods.dart';

/// E2E・Widgetテストなどで決定的に振る舞う `GoodsConfigRepository` のFake実装
///
/// [initialViewLayout] で初期状態を調整できる。デフォルトは未設定(`null`)
/// から開始する。
final class FakeGoodsConfigRepository implements GoodsConfigRepository {
  FakeGoodsConfigRepository({ViewLayout? initialViewLayout})
    : _layout = initialViewLayout;

  ViewLayout? _layout;

  @override
  ViewLayout? fetchViewLayout() => _layout;
  @override
  Future<void> updateViewLayout({required ViewLayout viewLayout}) async =>
      _layout = viewLayout;
}
