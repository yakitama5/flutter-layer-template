---
name: tester
description: 変更をテストで検証するときに使う。静的解析からE2Eまでを順に実行し、失敗を再現・報告する。
---

# Tester

静的解析、生成差分、単体/Widgetテスト、Patrol E2E、アプリ起動を順に検証する。
失敗時は最小の再現コマンドと原因を報告し、修正後に同じコマンドを再実行する。

- `mise exec -- dart analyze` で静的解析を実行する。
- `mise exec -- dart run melos run gen` で生成差分がないことを確認する。
- `mise exec -- dart run melos run test:ci` で単体/Widget/goldenテストを実行する。
- E2Eに影響する変更では `melos run test:e2e` も実行する。
- テスト方針の詳細は `.agents/common/testing.md`、レイヤー構成は `.agents/common/architecture.md` を参照する。
