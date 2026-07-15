# infrastructure_firebase

Firebase Auth、Firestore、Remote Configなどを利用するinfrastructure実装です。
domainのリポジトリ抽象を実装し、applicationやUIには依存しません。

環境別のFirebase Optionsは`lib/src/common/config`、ネイティブ設定はappの
`android/app/src/{dev,prd}`と`ios/{dev,prd}`へ配置します。

## Firebase設定のコード管理

リポジトリルートの`firebase/`で次の設定を管理します。

- `firestore.rules`: `users`と`_dusers`のスキーマ・所有者制約
- `firestore.indexes.json`: Firestore複合インデックス・field override
- `storage.rules`: ユーザー所有画像のパス・型・サイズ制約
- `remoteconfig.template.json`: アプリが参照するRemote Configパラメーター

Firebase ConsoleでルールやRemote Configを直接変更すると、次回デプロイでこのリポジトリの
内容に上書きされます。変更はファイルとテストを同じPull Requestで更新してください。

### ローカルテスト

```shell
mise install
npm ci --prefix firebase
mise exec -- npx --yes firebase-tools@15.23.0 emulators:exec \
  --only firestore,storage \
  --project demo-flutter-layer-template \
  "npm --prefix firebase test"
```

### ローカルデプロイ

Firebase CLIでログイン後、対象のProject IDを明示してデプロイします。

```shell
mise exec -- npx --yes firebase-tools@15.23.0 login
mise exec -- npx --yes firebase-tools@15.23.0 deploy \
  --only firestore,storage,remoteconfig \
  --project <FirebaseProjectID>
```

### GitHub Actionsデプロイ

GitHubの`dev`と`prd` Environmentへ次のEnvironment variableを設定します。

- `FIREBASE_PROJECT_ID`
- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT`

`Firebase Configuration` workflowを手動実行し、デプロイ先Environmentを選択します。
Pull Requestと`main`へのpushではEmulatorテストだけを実行します。
