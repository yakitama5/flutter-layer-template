<!-- markdownlint-disable MD029 -->
# ⬆️Flutter のアップグレード

## 手順

1. `mise use flutter@<upgrade version>` を実行
2. ルートの`pubspec.yaml` の `sdk`バージョンを更新
3. ルートの`pubspec.yaml` のmelos.bootstrapにある`sdk`, `flutter`部分のバージョンを更新

```yaml
melos: 
  command:
    bootstrap:
      environment:
        sdk: ^x.x.x
        flutter: ^x.x.x
```

4. `melos bootstrap`コマンドを実行
5. iOS でアプリが起動できることを確認
6. Android でアプリが起動できることを確認
7. [Migration Guide](https://docs.flutter.dev/release/breaking-changes) に従い、必要に応じて deprecate 箇所を修正

## 注意ポイント

- iOS Simulator や Android Emulator だけでなく、実機も動作することを確認
- Flutter 側だけでなく、 Android・iOS 側で利用しているパッケージ・プラグイン・ライブラリの更新が必要ないか確認
