import 'package:domain/user.dart';
import 'package:riverpod/riverpod.dart';

import '../../core/extension/ref_extension.dart';
import '../interface/user_repository.dart';

/// ユーザー
/// データの参照頻度を減らすため、参照されなくなってから30秒間はキャッシュを保持する
final userProvider = StreamProvider.autoDispose.family<User?, String>((
  ref,
  userId,
) {
  ref.cacheFor(const Duration(seconds: 30));

  return ref.watch(userRepositoryProvider).listen(userId: userId);
});
