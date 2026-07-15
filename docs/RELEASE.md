# リリース

GitHub Actionsの`Build and Publish`を手動実行します。

- `bump_type`: `major` / `minor` / `patch` / `build`
- `platform`: `all` / `android` / `ios`

ワークフローはciderで`apps/app/pubspec.yaml`を更新し、バージョンコミットとタグをpushした後、
同じバージョンのAndroid App Bundle / iOS IPAをビルドして各ストアへ配布します。
バージョン更新だけを行う独立ワークフローはありません。

必要なFirebase設定、署名情報、ストア認証情報はRepository Secrets/Variablesへ登録してください。
