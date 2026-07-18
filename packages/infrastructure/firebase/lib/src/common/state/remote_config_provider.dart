import 'package:domain/util.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:infrastructure_firebase/src/common/enum/remote_configs.dart';
import 'package:riverpod/riverpod.dart';

/// Firebase Remote Config
/// テスト時にDIすることを考慮して、Providerとして定義
final remoteConfigProvider = FutureProvider<FirebaseRemoteConfig>((ref) async {
  final res = FirebaseRemoteConfig.instance;

  // フェッチのタイムアウトと最小フェッチ間隔を設定
  await res.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );

  // デフォルト値を登録し、初回起動時やオフライン時でも安全に値を取得できるようにする
  await res.setDefaults({
    for (final config in RemoteConfigs.values) config.key: config.defaultValue,
  });

  try {
    // キャッシュ化してないと利用できないようにする
    await res.fetchAndActivate();
  } on Exception catch (e) {
    // オフライン初回起動時など、fetchに失敗した場合はデフォルト値/既存キャッシュのまま継続する
    logger.w('Remote ConfigのfetchAndActivateに失敗しました: $e');
  }

  return res;
});

/// 指定キーの値を継続的に監視するStream
///
/// 初回は現在の値を、以降は該当キーの更新をactivateした上で最新値を流す。
Stream<T> listenConfigValue<T>(
  FirebaseRemoteConfig remoteConfig,
  RemoteConfigs<T> config,
) async* {
  yield config.getValue(remoteConfig);
  yield* remoteConfig.onConfigUpdated
      .where((snapshot) => snapshot.updatedKeys.contains(config.key))
      .asyncMap((snapshot) async {
        await remoteConfig.activate();
        return config.getValue(remoteConfig);
      });
}
