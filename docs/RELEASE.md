# リリース

GitHub Actionsの`Build and Publish`を手動実行します。

- `bump_type`: `major` / `minor` / `patch` / `build`
- `platform`: `all` / `android` / `ios`

ワークフローはciderで`apps/app/pubspec.yaml`を更新し、バージョンコミットとタグをpushした後、
同じバージョンのAndroid App Bundle / iOS IPAをビルドして各ストアへ配布します。
バージョン更新だけを行う独立ワークフローはありません。

必要なFirebase設定、署名情報、ストア認証情報はRepository Secrets/Variablesへ登録してください。

## 🔐必要なSecrets/Variables

`check_pr.yaml`（旧`flutter_analyze.yaml`/`flutter_test.yaml`）はSecretsを必要としません。
以下は`build_and_publish.yaml`と`firebase_configuration.yaml`が参照するSecrets/Variablesです。

| 名前 | 種別 | 用途 | 使用箇所 |
|---|---|---|---|
| `ANDROID_KEYSTORE` | Secret | Androidの署名用keystore（base64） | Build and Publish |
| `ANDROID_KEYSTORE_PASSWORD` | Secret | keystoreのパスワード | Build and Publish |
| `ANDROID_KEY_PASSWORD` | Secret | 署名鍵のパスワード | Build and Publish |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS` | Secret | Google Play Consoleへの配布用サービスアカウント認証情報 | Build and Publish |
| `DART_DEFINE_JSON` | Secret | 本番用`--dart-define-from-file`設定（base64） | Build and Publish |
| `FIREBASE_OPTIONS` | Secret | 本番用`firebase_options.dart`（base64） | Build and Publish |
| `FIREBASE_OPTIONS_DEV` | Secret | 開発用`firebase_options_dev.dart`（base64） | Build and Publish |
| `GOOGLE_SERVICES_JSON` | Secret | Android本番用`google-services.json`（base64） | Build and Publish |
| `GOOGLE_INFO_PLIST` | Secret | iOS本番用`GoogleService-Info.plist`（base64） | Build and Publish |
| `ENV_FILE` | Secret | Firebase Functions等の本番用`.env`（base64） | Build and Publish |
| `DEV_ENV_FILE` | Secret | Firebase Functions等の開発用`.env.dev`（base64） | Build and Publish |
| `APP_STORE_CONNECT_PRIVATE_KEY` | Secret | App Store Connect APIキー | Build and Publish |
| `CERTIFICATE_PRIVATE_KEY` | Secret | iOS署名証明書の秘密鍵 | Build and Publish |
| `EXPORT_OPTIONS` | Secret | iOSビルド用`ExportOptions.plist`（base64） | Build and Publish |
| `ANDROID_KEYSTORE_FILENAME` | Variable | keystoreファイル名 | Build and Publish |
| `ANDROID_KEY_ALIAS` | Variable | 署名鍵のエイリアス | Build and Publish |
| `APP_STORE_CONNECT_ISSUER_ID` | Variable | App Store Connect APIのIssuer ID | Build and Publish |
| `APP_STORE_CONNECT_KEY_IDENTIFIER` | Variable | App Store Connect APIのKey ID | Build and Publish |
| `GCP_WORKLOAD_IDENTITY_PROVIDER` | Variable | Firebaseデプロイ用Workload Identity連携先 | Firebase Configuration |
| `GCP_SERVICE_ACCOUNT` | Variable | Firebaseデプロイ用サービスアカウント | Firebase Configuration |
| `FIREBASE_PROJECT_ID` | Variable | デプロイ先FirebaseプロジェクトID | Firebase Configuration |

`GCP_WORKLOAD_IDENTITY_PROVIDER` / `GCP_SERVICE_ACCOUNT` / `FIREBASE_PROJECT_ID` は
GitHub Environment（`dev` / `prd`）ごとに登録します。詳細は
`packages/infrastructure/firebase/README.md`を参照してください。

`pr_labeler.yaml`が参照する`secrets.GITHUB_TOKEN`はGitHub Actionsが自動発行するトークンのため、
登録作業は不要です。
