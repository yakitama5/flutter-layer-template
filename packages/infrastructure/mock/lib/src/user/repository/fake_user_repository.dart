import 'dart:async';

import 'package:domain/user.dart';

/// E2E・Widgetテストなどで決定的に振る舞う `UserRepository` のFake実装
///
/// [initialAuthStatus] で初期認証状態を調整できる。デフォルトは未認証
/// (`null`)から開始する。[signUp] を呼ぶと [signUpAuthStatus] で指定した
/// 認証状態(デフォルトは匿名ユーザー)を発行する。
final class FakeUserRepository implements UserRepository {
  FakeUserRepository({
    this.initialAuthStatus,
    this.signUpAuthStatus = const AuthStatus(
      uid: 'e2e-user',
      isAnonymous: true,
      linkedGoogle: false,
      linkedApple: false,
    ),
  });

  /// [listenAuthStatus] が最初に発行する認証状態(デフォルトは未認証)
  final AuthStatus? initialAuthStatus;

  /// [signUp] 呼び出し時に発行する認証状態
  final AuthStatus signUpAuthStatus;
  final _authStatus = StreamController<AuthStatus?>.broadcast();

  @override
  Stream<AuthStatus?> listenAuthStatus() async* {
    yield initialAuthStatus;
    yield* _authStatus.stream;
  }

  @override
  Future<void> signUp() async => _authStatus.add(signUpAuthStatus);

  @override
  Stream<User?> listen({required String userId}) => Stream.value(null);

  @override
  Future<void> delete({required String userId}) async {}

  @override
  Future<AuthStatus> signInAnonymously() => throw UnimplementedError();

  @override
  Future<AuthStatus> signInWithApple() => throw UnimplementedError();

  @override
  Future<AuthStatus> signInWithGoogle() => throw UnimplementedError();

  @override
  Future<void> signOut() async {}

  @override
  Future<void> unlinkWithApple() async {}

  @override
  Future<void> unlinkWithGoogle() async {}
}
