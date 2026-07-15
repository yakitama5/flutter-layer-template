# designsystem

テーマ、共通Widget、UI拡張、共通ローカライズを提供します。
永続化が必要なテーマ状態はapplicationが公開する`ThemeRepository` Providerへ依存し、
SharedPreferencesの具体実装を直接参照しません。
