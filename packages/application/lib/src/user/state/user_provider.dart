import 'package:domain/user.dart';
import 'package:riverpod/riverpod.dart';

import '../interface/user_repository.dart';

/// ユーザー
/// データの参照頻度を減らすため、`keepAlive`を指定
final userProvider = StreamProvider.family<User?, String>(
  (ref, userId) => ref.watch(userRepositoryProvider).listen(userId: userId),
);
