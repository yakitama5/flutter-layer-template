import 'package:collection/collection.dart';
import 'package:domain/designsystem.dart';
import 'package:domain/goods.dart';
import 'package:infrastructure_shared_preferences/common.dart';
import 'package:infrastructure_shared_preferences/src/common/enum/preferences.dart';
import 'package:riverpod/riverpod.dart';

class SharedPreferencesGoodsConfigRepository implements GoodsConfigRepository {
  const SharedPreferencesGoodsConfigRepository(this.ref);

  final Ref ref;

  @override
  ViewLayout? fetchViewLayout() {
    final value = ref.watch(
      stringPreferenceProvider(Preferences.goodsViewLayout),
    );
    return ViewLayout.values.firstWhereOrNull((e) => e.name == value);
  }

  @override
  Future<void> updateViewLayout({required ViewLayout viewLayout}) => ref
      .read(stringPreferenceProvider(Preferences.goodsViewLayout).notifier)
      .update(viewLayout.name);
}
