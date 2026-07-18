# Architecture

- `foundation`: logger・uuid・拡張関数などの純粋ユーティリティ。全レイヤーから依存可、外部フレームワークへ依存しない。
- `domain`: エンティティ、値オブジェクト、リポジトリ抽象、純粋な業務ルール。
- `application`: ユースケース、状態、リポジトリ抽象を注入するProvider。
- `infrastructure`: domainのリポジトリ抽象を実装する外部I/O。
- `designsystem`: UI部品とテーマ。状態が必要な場合はapplicationの抽象へ依存する。
- `app`: 画面、ルーティング、ローカライズ、composition root。
- `dependency_override`: applicationのProviderとinfrastructure実装を結線する。

内側のレイヤーから外側のレイヤーをimportしてはならない。

## 例外ハンドリング

- infrastructure層で外部SDK(Firebase, google_sign_in等)の例外を捕捉し、
  `domain`の`AppException`階層へ変換してからthrowする。
- ユーザー操作によるキャンセル(サインイン中断等)は`CancelledByUserException`とし、
  UIへの通知は不要として扱う。
- presentation層は`PresentationMixin.execute`経由でユースケースを実行し、
  `AppException`のハンドリングをそこに集約する。
- 模範実装は`packages/infrastructure/firebase/lib/src/user/repository/firebase_user_repository.dart`
  および同階層の`common/util/firebase_exception_handler.dart`。
