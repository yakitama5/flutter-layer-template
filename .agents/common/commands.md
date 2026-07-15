# Commands

- 依存解決: `mise exec -- dart pub get`
- コード生成: `mise exec -- dart run melos run gen`
- 静的解析: `mise exec -- dart analyze`
- 全テスト: `mise exec -- dart run melos run test:ci`
- Patrol E2E: `cd apps/app && mise exec -- patrol test --target integration_test/app_flow_test.dart --dart-define-from-file=flavor/dev.json`
