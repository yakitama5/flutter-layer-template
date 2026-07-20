import 'dart:async';

import 'package:alchemist/alchemist.dart';

/// designsystemパッケージのgoldenテスト共通設定。
///
/// `flutter_test_config.dart` はパッケージ内の全テスト実行前に読み込まれる。
/// CI環境(`--dart-define=CI=true`)ではプラットフォーム依存の描画差異を避けるため、
/// プラットフォームgolden(`goldens/<platform>/`)の比較を無効化し、
/// CI golden(`goldens/ci/`)のみを比較する。
/// ローカル実行時はプラットフォームgoldenとCI goldenの両方を有効にする
/// (alchemistのデフォルト動作)。
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // ignore: do_not_use_environment
  const isCi = bool.fromEnvironment('CI');

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isCi),
    ),
    run: testMain,
  );
}
