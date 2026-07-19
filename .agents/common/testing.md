# Testing

- 純粋なロジックは単体テスト、WidgetはFlutterテスト、主要ユーザーフローはPatrolで検証する。
- E2Eは外部サービスを直接呼ばず、Provider overrideで決定的なfakeを注入する。
- テストは表示結果だけでなく、ユーザーが実際に行うtapと画面遷移を含める。
- 失敗を再現してから修正し、変更範囲に応じて全パッケージを再検証する。

## 配置とレイヤー別作法

- 配置: 各パッケージの `test/` ディレクトリ。melosの `test:ci` は `dirExists: test` の
  パッケージのみが対象。
- domain: 純粋Dartの単体テスト(値オブジェクト・業務ルール)。
- application: `ProviderContainer` にリポジトリProviderをoverrideするproviderテスト。
- designsystem: alchemistによるgoldenテスト。`flutter_test_config.dart` で
  `bool.fromEnvironment('CI')` を配線し、CI環境ではCI用ゴールデンと比較する。
  goldenテストには `@Tags(['golden'])` を付与し `melos run test:golden` で実行する。
- app: ルーティング・画面のWidgetテスト。
- fake/mock: 再利用可能な決定的fakeは `packages/infrastructure/mock` に集約し、
  E2Eとproviderテスト双方から参照する。テストファイル内への自前fake定義は避ける。
  ただしapplicationのproviderテストは、`packages/infrastructure/mock` がapplicationに
  依存しており参照すると循環依存になるため、テストに必要な最小限のfakeをテストファイル内に
  定義してよい。集約対象の決定的fakeはE2Eなどinfrastructureに依存できる層で使うものに限る。
- Firestore/Storageルール: `firebase/test/*.rules.test.mjs` で検証する。
  ルール変更時はupdate系を含むテスト追加を必須とする。

## 実行コマンド

- `melos run test:ci` / `melos run test:golden` / `melos run test:e2e`
