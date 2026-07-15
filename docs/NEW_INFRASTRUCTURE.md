# Infrastructureパッケージの追加

`packages/infrastructure/<name>`にDart/Flutterパッケージを作成し、次を守ります。

1. domainが公開するリポジトリ抽象を実装する。
2. workspaceへパッケージを追加する。
3. dependency_overrideから実装をProviderへ結線する。
4. 外部I/Oを使わない単体テストを追加する。
5. コード生成対象が存在する場合だけ`build.yaml`と`build_runner`を追加する。

このリポジトリにはMason brickを同梱していないため、`mason make`手順はありません。
