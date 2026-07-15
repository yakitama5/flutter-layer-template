# flutter_app

Android/iOS向けのpresentation層とcomposition rootです。

環境は`dev`と`prd`の2種類で、Dart Defineは`flavor/dev.json`または`flavor/prd.json`を使います。

```shell
flutter run --dart-define-from-file=flavor/dev.json
```

主要ユーザーフローは`integration_test/app_flow_test.dart`のPatrol E2Eで検証します。

## アプリIDの変更

リポジトリルートで次のコマンドを実行すると、AndroidとiOSのアプリIDを一括変更できます。
開発環境の`.dev` suffixは維持されます。

```shell
mise exec -- dart run tool/replace_app_id.dart --app-id com.example.app
```

変更予定だけを確認する場合は`--dry-run`を付けます。GitHubの`Replace App ID`
workflowを手動実行して、選択したブランチへ変更をコミットすることもできます。

置換後は新しいアプリIDをFirebaseプロジェクトへ登録し、
`docs/GET_STARTED.md`の手順でFirebase設定ファイルを再生成してください。
