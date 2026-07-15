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

リリース手順は[RELEASE.md](RELEASE.md)を参照してください。
<!-- Links -->

[Visual Studio Code]: https://code.visualstudio.com/

[Xcode]: https://developer.apple.com/xcode/

[mise]: https://mise.jdx.dev/

[melos]: https://melos.invertase.dev/

[Firebase CLI]: https://firebase.google.com/docs/cli?hl=ja

[FlutterFire CLI]: https://firebase.google.com/docs/flutter/setup?hl=ja
