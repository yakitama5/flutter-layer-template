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

/// Firebase系の例外を[AppException]へ変換して再throwする
///
/// [guardFirebaseException]（Future用）と[guardFirebaseExceptionStream]
/// （Stream用）で共有する変換ロジック。変換対象外の例外は元の例外・スタック
/// トレースのまま再throwする。
Never _throwAsAppException(Object error, StackTrace stackTrace) {
  if (error is AppException) {
    // 変換済みの例外はそのまま再throw
    Error.throwWithStackTrace(error, stackTrace);
  } else if (error is auth.FirebaseAuthException) {
    switch (error.code) {
      case 'requires-recent-login':
        throw const RequiresRecentLoginException();
      case 'network-request-failed':
        throw const UnknownNetworkException();
      case _ when _cancelledAuthErrorCodes.contains(error.code):
        throw const CancelledByUserException();
      default:
        logger.w(
          'FirebaseAuthException: ${error.code}',
          error: error,
          stackTrace: stackTrace,
        );
        throw const UnknownException();
    }
  } else if (error is auth.FirebaseException) {
    logger.w(
      'FirebaseException: ${error.code}',
      error: error,
      stackTrace: stackTrace,
    );
    throw const UnknownException();
  } else if (error is GoogleSignInException) {
    if (_cancelledGoogleSignInCodes.contains(error.code)) {
      throw const CancelledByUserException();
    }
    logger.w(
      'GoogleSignInException: ${error.code}',
      error: error,
      stackTrace: stackTrace,
    );
    throw const SignInFailedException();
  } else if (error is PlatformException) {
    logger.w(
      'PlatformException: ${error.code}',
      error: error,
      stackTrace: stackTrace,
    );
    throw const UnknownException();
  } else {
    Error.throwWithStackTrace(error, stackTrace);
  }
}

/// Firebase系の例外を[AppException]へ変換して再throwする共通ハンドラ
///
/// infrastructure層で外部SDKの例外を[AppException]へ変換するための
/// 模範実装。詳細は`.agents/common/architecture.md`を参照。
Future<T> guardFirebaseException<T>(Future<T> Function() action) async {
  try {
    return await action();
  } catch (e, stackTrace) {
    _throwAsAppException(e, stackTrace);
  }
}

/// [guardFirebaseException]のStream版
///
/// 購読中に発生したFirebase系例外(ネットワーク断等)も[AppException]へ
/// 変換してからStreamのエラーイベントとして流す。
Stream<T> guardFirebaseExceptionStream<T>(Stream<T> stream) {
  return stream.handleError(_throwAsAppException);
}
