import '../entity/auth_status.dart';
import '../entity/user.dart';

/// ユーザーモデル および ユーザーの認証に関するリポジトリ
abstract class UserRepository {
  /// ユーザーモデルの取得
  Stream<User?> listen({required String userId});

  /// サインアップ および ユーザー/グループモデルの追加
  Future<void> signUp();

  /// ユーザーモデル および 認証アカウントの削除
  Future<void> delete({required String userId});

  /// 認証状態の取得
  Stream<AuthStatus?> listenAuthStatus();

  /// 匿名ログイン
  Future<AuthStatus> signInAnonymously();

  /// Googleアカウントとの連携
  Future<AuthStatus> signInWithGoogle();

  /// Appleアカウントとの連携
  Future<AuthStatus> signInWithApple();

  /// Googleアカウントとの連携を解除
  Future<void> unlinkWithGoogle();

  /// Appleアカウントとの連携を解除
  Future<void> unlinkWithApple();

  /// サインアウト
  Future<void> signOut();
}
