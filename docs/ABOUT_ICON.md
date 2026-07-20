# 🖼️アイコンについて

## 🍎iOS

- iOSのアイコンの場合、Apple Storeで使用されている画像サイズは1024x1024で、それ以外のサイズの場合は[icons_launcher]が自動的に小さいものを生成します。
- アイコンのサイズは1024x1024以下でも問題ありませんが、小さすぎると画質が悪いアイコンになる可能性があります。

## 🍨Android

- Adaptive Launcher IconsはAndroid 8.0（APIレベル26）で導入され、デバイスの種類ごとに異なる形で表示できるようになりました。
  - `adaptive_icon_foreground`
    - ロゴまたはアイコン画像
    - 画像のサイズは1024x1024。
    - アイコンの大きさは画像の大きさの0.67倍程度にすると収まりが良い。

  - `adaptive_icon_background`
    - アイコンの背景画像
    - カラーコードまたは背景画像が必須。
    - 画像のサイズは1024x1024。

- 端末側では`adaptive_icon_foreground`と`adaptive_icon_background`の2つのレイヤーが
  合成され、円形・角丸四角形など端末ごとの形状にトリミングされて表示されます。
  前景画像は余白（セーフゾーン）を持たせ、画像全体の0.67倍程度の大きさに収めると
  見切れを防げます。
- 具体的なアイコン画像のサンプルは[adaptive icon guide]を確認してください。

<!-- Links -->

[icons_launcher]: https://pub.dev/packages/icons_launcher

[adaptive icon guide]: https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive?hl=ja
