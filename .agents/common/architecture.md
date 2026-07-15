# Architecture

- `domain`: エンティティ、値オブジェクト、リポジトリ抽象、純粋な業務ルール。
- `application`: ユースケース、状態、リポジトリ抽象を注入するProvider。
- `infrastructure`: domainのリポジトリ抽象を実装する外部I/O。
- `designsystem`: UI部品とテーマ。状態が必要な場合はapplicationの抽象へ依存する。
- `app`: 画面、ルーティング、ローカライズ、composition root。
- `dependency_override`: applicationのProviderとinfrastructure実装を結線する。

内側のレイヤーから外側のレイヤーをimportしてはならない。
