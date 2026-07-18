# Flutter Layer Template Agent Guide

このリポジトリでは Claude Code と Codex が同じ開発規約を共有する。
共通のエージェント・コマンド・スキル定義は `.agents/` を唯一の実体とし、
ツール固有ディレクトリには複製しない。

## 基本ルール

- 会話とドキュメントは日本語、コード上の識別子は英語を使う。
- 変更前に対象パッケージの `README.md` と `docs/ARCHITECTURE.md` を確認する。
- 依存方向は `app -> designsystem/application -> domain -> foundation` および
  `dependency_override -> application/infrastructure -> domain` を守る。
- domain は Flutter、Riverpod、Firebase、SharedPreferences に依存させない。
- foundation は Flutter、Riverpod、Firebase に依存させない純粋ユーティリティ層とする。
- Riverpod はコード生成を使わず、通常の Provider API で定義する。
- 完了前に `melos run gen`、`dart analyze`、`melos run test:ci` を実行する。
- E2Eに影響する変更では `melos run test:e2e` も実行する。

## 段階的に読む定義

- アーキテクチャ: `.agents/common/architecture.md`
- テスト: `.agents/common/testing.md`
- モノレポ操作: `.agents/common/commands.md`
- 実装: `.agents/agents/implementer.md`
- レビュー: `.agents/agents/reviewer.md`
- テスト検証: `.agents/agents/tester.md`
