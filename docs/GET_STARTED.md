# 🔰はじめに

## 💻ローカルセットアップ

以降の作業はOSに依存しない作業内容になります。
`make`コマンドを有効化している場合は、`make setup`コマンドを実行してください。

### ツールのインストール

- IDE をインストールしてください。
  - [Visual Studio Code]
    - `extension.json` に定義されている拡張機能をインストールしてください。
  - [Xcode]
- [mise] コマンドを有効にしてください。
- `make setup`でMelosと依存関係をセットアップできます。

### Flutter SDKのセットアップ

```shell
mise install
```

### mise でインストールした Flutter SDK を IDE で使用

ウィンドウをリロードして SDK を再読み込みしてください。

### 依存関係のインストール

```shell
make setup
```

## 🔥Firebase

> [!WARNING]
> このテンプレートに含まれる Firebase 設定（`firebase_options.dart` /
> `firebase_options_dev.dart` / `google-services.json` /
> `GoogleService-Info.plist`）は、すべて `your-project-id` などの
> **ダミー値** です。実プロジェクトの値へ差し替えないと、
> `FirebaseInitializer.initialize` が起動時に `StateError` を送出してアプリが
> 停止します。テンプレート利用時は必ず下記手順の `flutterfire configure` を
> 実行し、自分の Firebase プロジェクトの設定へ差し替えてください。

Firebaseを利用する場合は下記の手順を実施してください。

### Firebase CLIツールのインストール

- [Firebase CLI] をインストールしてください。

    ```shell
    npm install -g firebase-tools
    firebase login
    ```

- [FlutterFire CLI] コマンドを有効にしてください。

    ```shell
    dart pub global activate flutterfire_cli
    ```
  
  - プロジェクト毎にコマンドを叩いて設定ファイルを作成してください。

    ```shell
    # 開発環境
    flutterfire configure --out=packages/infrastructure/firebase/lib/src/common/config/firebase_options_dev.dart -p [DevProjectID] --platforms=android,ios -i [BundleID].dev -a [AppID].dev

    # 本番環境
    flutterfire configure --out=packages/infrastructure/firebase/lib/src/common/config/firebase_options.dart -p [ProjectID] --platforms=android,ios -i [BundleID] -a [AppID]
    ```
  
  - 下記のファイルをそれぞれ環境別のディレクトリに配置する
    - `GoogleService-Info.plist`
      - 開発：`apps/app/ios/dev/GoogleService-Info.plist`
      - 本番：`apps/app/ios/prd/GoogleService-Info.plist`
    - `google-services.json`
      - 開発：`apps/app/android/app/src/dev/google-services.json`
      - 本番：`apps/app/android/app/src/prd/google-services.json`

Firestore、Storage、Remote Configのスキーマ・ルール・パラメーターは`firebase/`で管理します。
ローカルテスト、デプロイ、GitHub Environmentの設定方法は
`packages/infrastructure/firebase/README.md`を参照してください。

## テスト

```shell
# 静的解析と全パッケージのテスト
mise exec -- dart analyze
mise exec -- dart run melos run test:ci

# Patrol E2E（起動済みのAndroid/iOSエミュレータが必要）
mise exec -- dart pub global activate patrol_cli
cd apps/app
mise exec -- patrol test --target integration_test/app_flow_test.dart \
  --dart-define-from-file=flavor/dev.json
```

## 📱動作確認

このアプリを実行するための実行構成が設定されています。

Please check:

- [Visual Studio Code] の場合、`.vscode/launch.json` を確認してください。

## アプリIDの変更

テンプレート利用開始時に、AndroidとiOSで共通のベースアプリIDを指定します。

```shell
# 変更対象の確認
mise exec -- dart run tool/replace_app_id.dart \
  --app-id com.example.app \
  --dry-run

# 変更の適用
mise exec -- dart run tool/replace_app_id.dart \
  --app-id com.example.app
```

このツールはflavor、Android namespaceとKotlin package、iOS、Patrol、E2E、
Firebase設定内のアプリIDを同期します。開発環境には既存の`.dev` suffixが付きます。

GitHub上で実行する場合はActionsの`Replace App ID`を開き、変更先のブランチと
アプリIDを指定して`Run workflow`を実行します。workflowは検証後、選択したブランチへ
変更をコミットします。

アプリIDの変更だけではFirebase側に新しいアプリは作成されません。変更後に開発・本番の
FirebaseプロジェクトへAndroid/iOSアプリを登録し直し、このドキュメントのFirebase節に
従って`flutterfire configure`とネイティブ設定ファイルの配置を再実行してください。

リリース手順は[RELEASE.md](RELEASE.md)を参照してください。
<!-- Links -->

[Visual Studio Code]: https://code.visualstudio.com/

[Xcode]: https://developer.apple.com/xcode/

[mise]: https://mise.jdx.dev/

[melos]: https://melos.invertase.dev/

[Firebase CLI]: https://firebase.google.com/docs/cli?hl=ja

[FlutterFire CLI]: https://firebase.google.com/docs/flutter/setup?hl=ja
