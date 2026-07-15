import 'package:domain/user.dart';
import 'package:riverpod/riverpod.dart';

import 'auth_status_provider.dart';
import 'user_provider.dart';

/// 認証済のユーザー
/// データの参照頻度を減らすため、`keepAlive`を指定
final authUserProvider = FutureProvider<User?>((ref) async {
  final userId = await ref.watch(
    authStatusProvider.selectAsync((value) => value?.uid),
  );
  if (userId == null) {
    return null;
  }

  final user = await ref.watch(userProvider(userId).future);

  return user;
});
