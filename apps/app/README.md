# flutter_app

Android/iOS向けのpresentation層とcomposition rootです。

環境は`dev`と`prd`の2種類で、Dart Defineは`flavor/dev.json`または`flavor/prd.json`を使います。

```shell
flutter run --dart-define-from-file=flavor/dev.json
```

主要ユーザーフローは`integration_test/app_flow_test.dart`のPatrol E2Eで検証します。
