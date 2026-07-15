import 'package:domain/user.dart';
import 'package:riverpod/riverpod.dart';

import '../interface/user_repository.dart';

/// 認証状態
final authStatusProvider = StreamProvider<AuthStatus?>(
  (ref) => ref.watch(userRepositoryProvider).listenAuthStatus(),
);
