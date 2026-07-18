sealed class AppException implements Exception {
  const AppException(this.message);

  final String? message;
}

sealed class BusinessException extends AppException {
  const BusinessException(super.message);
}

sealed class PermissionException extends BusinessException {
  const PermissionException(super.message);
}

class NotAuthException extends PermissionException {
  const NotAuthException(super.message);
}

/// 直近の再認証が必要な操作(アカウント削除等)で発生する例外
///
/// UIは再認証フローへ誘導する用途で使用する。
class RequiresRecentLoginException extends PermissionException {
  const RequiresRecentLoginException([super.message]);
}

/// ユーザー操作によるキャンセル(サインイン中断等)を表す例外
///
/// UIはユーザーへの通知不要として扱う。
class CancelledByUserException extends BusinessException {
  const CancelledByUserException([super.message]);
}

sealed class NetworkException extends AppException {
  const NetworkException(super.message);

  factory NetworkException.fromStatusCode(int? statusCode) {
    if (statusCode == null) {
      return const UnknownNetworkException();
    }

    return switch (statusCode) {
      >= 400 && < 500 => ClientNetworkException(
        'Client error occurred($statusCode)',
      ),
      >= 500 && < 600 => ServerNetworkException(
        'Server error occurred($statusCode)',
      ),
      _ => throw ArgumentError(
        'Invalid status code: $statusCode.',
        'statusCode',
      ),
    };
  }
}

class ClientNetworkException extends NetworkException {
  const ClientNetworkException(super.message);
}

class ServerNetworkException extends NetworkException {
  const ServerNetworkException(super.message);
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException() : super('Unknown network error occurred');
}

class UnknownException extends AppException {
  const UnknownException() : super('Unknown error occurred');
}

/// サインイン結果が不正な場合の例外(credential.userがnull等)
class SignInFailedException extends AppException {
  const SignInFailedException([super.message]);
}
