import 'package:domain/core.dart';
import 'package:test/test.dart';

void main() {
  group('NetworkException.fromStatusCode', () {
    test('400台のステータスコードはClientNetworkExceptionを返す', () {
      expect(
        NetworkException.fromStatusCode(400),
        isA<ClientNetworkException>(),
      );
      expect(
        NetworkException.fromStatusCode(404),
        isA<ClientNetworkException>(),
      );
      expect(
        NetworkException.fromStatusCode(499),
        isA<ClientNetworkException>(),
      );
    });

    test('500台のステータスコードはServerNetworkExceptionを返す', () {
      expect(
        NetworkException.fromStatusCode(500),
        isA<ServerNetworkException>(),
      );
      expect(
        NetworkException.fromStatusCode(503),
        isA<ServerNetworkException>(),
      );
      expect(
        NetworkException.fromStatusCode(599),
        isA<ServerNetworkException>(),
      );
    });

    test('ステータスコードがnullの場合はUnknownNetworkExceptionを返す', () {
      expect(
        NetworkException.fromStatusCode(null),
        isA<UnknownNetworkException>(),
      );
    });

    test('メッセージにステータスコードが含まれる', () {
      final exception = NetworkException.fromStatusCode(404);
      expect(exception.message, contains('404'));
    });

    test('範囲外のステータスコードはArgumentErrorをthrowする', () {
      // 400未満
      expect(
        () => NetworkException.fromStatusCode(399),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => NetworkException.fromStatusCode(200),
        throwsA(isA<ArgumentError>()),
      );
      // 600以上
      expect(
        () => NetworkException.fromStatusCode(600),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
