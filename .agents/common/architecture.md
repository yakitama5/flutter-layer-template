# Architecture

- `foundation`: logger・uuid・拡張関数などの純粋ユーティリティ。全レイヤーから依存可、外部フレームワークへ依存しない。
- `domain`: エンティティ、値オブジェクト、リポジトリ抽象、純粋な業務ルール。
- `application`: ユースケース、状態、リポジトリ抽象を注入するProvider。
- `infrastructure`: domainのリポジトリ抽象を実装する外部I/O。
- `designsystem`: UI部品とテーマ。状態が必要な場合はapplicationの抽象へ依存する。
- `app`: 画面、ルーティング、ローカライズ、composition root。
- `dependency_override`: applicationのProviderとinfrastructure実装を結線する。

内側のレイヤーから外側のレイヤーをimportしてはならない。

## 命名規則

- Notifierのクラス名は`<対象>Notifier`サフィックスを付ける。状態の値型(例: `UIStyle`)と
  混同しないためで、`UiStyleNotifier`のように命名する。
- Providerは原則`autoDispose`を既定とする。アプリ全域で生存させたいものだけ非`autoDispose`にする。
  familyは`autoDispose` + 必要に応じて`cacheFor`(`packages/application/lib/src/core/extension/ref_extension.dart`)
  を併用し、参照が途切れてから一定時間キャッシュを保持する。
- パッケージ名は歴史的経緯で`packages_`接頭辞の有無が混在している(`domain`/`designsystem`と
  `packages_application`/`packages_foundation`等)。これはimportの別名衝突を避けるための対応であり、
  新規パッケージは接頭辞なしの名前を優先し、既存パッケージ名は互換のため維持する。

## 例外ハンドリング

- infrastructure層で外部SDK(Firebase, google_sign_in等)の例外を捕捉し、
  `domain`の`AppException`階層へ変換してからthrowする。
- ユーザー操作によるキャンセル(サインイン中断等)は`CancelledByUserException`とし、
  UIへの通知は不要として扱う。
- presentation層は`PresentationMixin.execute`経由でユースケースを実行し、
  `AppException`のハンドリングをそこに集約する。
- 模範実装は`packages/infrastructure/firebase/lib/src/user/repository/firebase_user_repository.dart`
  および同階層の`common/util/firebase_exception_handler.dart`。
