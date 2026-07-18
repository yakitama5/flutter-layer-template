import 'package:domain/core.dart';
import 'package:domain/util.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// キャンセル系として扱う[auth.FirebaseAuthException]のcode一覧
///
/// サインインの中断等、ユーザー操作によるキャンセルを表すcode。
const _cancelledAuthErrorCodes = {
  'canceled',
  'web-context-canceled',
  'popup-closed-by-user',
  'user-cancelled',
};

/// キャンセル系として扱う[GoogleSignInExceptionCode]一覧
const _cancelledGoogleSignInCodes = {
  GoogleSignInExceptionCode.canceled,
  GoogleSignInExceptionCode.interrupted,
};

/// Firebase系の例外を[AppException]へ変換して再throwする共通ハンドラ
///
/// infrastructure層で外部SDKの例外を[AppException]へ変換するための
/// 模範実装。詳細は`.agents/common/architecture.md`を参照。
Future<T> guardFirebaseException<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on AppException {
    // 変換済みの例外はそのまま再throw
    rethrow;
  } on auth.FirebaseAuthException catch (e, stackTrace) {
    switch (e.code) {
      case 'requires-recent-login':
        throw const RequiresRecentLoginException();
      case 'network-request-failed':
        throw const UnknownNetworkException();
      case _ when _cancelledAuthErrorCodes.contains(e.code):
        throw const CancelledByUserException();
      default:
        logger.w('FirebaseAuthException: ${e.code}', error: e, stackTrace: stackTrace);
        throw const UnknownException();
    }
  } on auth.FirebaseException catch (e, stackTrace) {
    logger.w('FirebaseException: ${e.code}', error: e, stackTrace: stackTrace);
    throw const UnknownException();
  } on GoogleSignInException catch (e, stackTrace) {
    if (_cancelledGoogleSignInCodes.contains(e.code)) {
      throw const CancelledByUserException();
    }
    logger.w('GoogleSignInException: ${e.code}', error: e, stackTrace: stackTrace);
    throw const SignInFailedException();
  } on PlatformException catch (e, stackTrace) {
    logger.w('PlatformException: ${e.code}', error: e, stackTrace: stackTrace);
    throw const UnknownException();
  }
}
