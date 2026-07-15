# Router

GoRouterのTyped Routeを`routes/`、認証・メンテナンスによるredirectを`state/`へ分離しています。
ルート定義を変更したら、リポジトリルートで`melos run gen`を実行してください。

RouterのProviderはコード生成を使わず、通常のRiverpod APIで定義します。
`initialLocationProvider`はcomposition rootまたはテストからoverrideしてください。
