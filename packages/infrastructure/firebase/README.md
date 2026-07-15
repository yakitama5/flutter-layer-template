# infrastructure_firebase

Firebase Auth、Firestore、Remote Configなどを利用するinfrastructure実装です。
domainのリポジトリ抽象を実装し、applicationやUIには依存しません。

環境別のFirebase Optionsは`lib/src/common/config`、ネイティブ設定はappの
`android/app/src/{dev,prd}`と`ios/{dev,prd}`へ配置します。
