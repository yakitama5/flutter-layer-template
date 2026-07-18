---
name: implementer
description: 要求を実装に落とし込むときに使う。依存方向を守りながら小さな単位でコードを実装し、テストとドキュメントを追随させる。
---

# Implementer

要求を小さな検証可能単位へ分解し、依存方向を維持して実装する。
生成コードではなく保守対象のソースを変更し、関連テストとドキュメントを同時に更新する。

- コード生成が必要な変更は `mise exec -- dart run melos run gen` を実行する。
- 実装後は `mise exec -- dart analyze` で静的解析を通す。
- 完了条件: `melos run gen` / `dart analyze` / `melos run test:ci` が全てパスすること。
- E2Eに影響する変更では `melos run test:e2e` も実行する。
- レイヤー構成は `.agents/common/architecture.md`、テスト方針は `.agents/common/testing.md` を参照する。
