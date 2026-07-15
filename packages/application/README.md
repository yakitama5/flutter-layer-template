# application

アプリケーション層です。domainのリポジトリ抽象をProviderとして公開し、
ユースケースと画面横断の状態を構成します。UIやFirebaseなどの具体実装には依存しません。

Providerは`riverpod_generator`を使わず、通常のRiverpod APIで定義します。
