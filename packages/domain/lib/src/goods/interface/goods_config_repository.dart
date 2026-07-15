import 'package:domain/src/designsystem/value_object/view_layout.dart';

abstract class GoodsConfigRepository {
  ViewLayout? fetchViewLayout();

  Future<void> updateViewLayout({required ViewLayout viewLayout});
}
