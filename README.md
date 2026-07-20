# Flutter Layer Template

Flutterでレイヤードアーキテクチャ（オニオンアーキテクチャの依存性逆転）を採用した
モノレポテンプレートです。Riverpod・GoRouter・Firebase・melosを使った構成になっています。

詳しいセットアップ手順は[docs/GET_STARTED.md](docs/GET_STARTED.md)を参照してください。

## ✨特徴

- `domain` / `application` / `infrastructure` / `designsystem` / `dependency_override` /
  `foundation` / `app`に分かれたレイヤー構成（詳細は[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)）
- melosで管理するマルチパッケージのFlutterワークスペース
- `apps/app/flavor`によるマルチflavor構成（開発・本番）
- Firestore/Storage/Remote Configのルール・スキーマをコードとして`firebase/`で管理し、
  GitHub Actionsで検証・デプロイ
- `tool/replace_app_id.dart`（またはGitHub Actionsの`Replace App ID`）によるアプリID一括置換
- Claude CodeとCodexで共有するAIエージェント規約（`.agents/`、`AGENTS.md`）

## 📖ドキュメント

| ドキュメント | 内容 |
|---|---|
| [docs/GET_STARTED.md](docs/GET_STARTED.md) | ローカルセットアップ、Firebase設定、テンプレート利用開始チェックリスト |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | レイヤー構成と依存方向 |
| [docs/BRANCH.md](docs/BRANCH.md) | ブランチ保護ルールとステータスチェック |
| [docs/RELEASE.md](docs/RELEASE.md) | リリース手順と必要なSecrets/Variables |
| [docs/SPLASH_SCREEN.md](docs/SPLASH_SCREEN.md) | スプラッシュ画面の設定手順 |
| [docs/ABOUT_ICON.md](docs/ABOUT_ICON.md) | アプリアイコンの仕様 |
| [docs/NEW_INFRASTRUCTURE.md](docs/NEW_INFRASTRUCTURE.md) | infrastructureパッケージの追加手順 |
| [docs/UPGRADE_FLUTTER.md](docs/UPGRADE_FLUTTER.md) | Flutter SDKのアップグレード手順 |

## 📜ライセンス

このリポジトリは[MIT License](LICENSE)の下で公開しています。
