# domain

最内周のドメイン層です。エンティティ、値オブジェクト、リポジトリ抽象、
純粋な業務ルールだけを含みます。Flutter、Riverpod、Firebaseなど外側の技術へ依存しません。

Freezed/JSONのデータコードだけは`build_runner`で生成します。
