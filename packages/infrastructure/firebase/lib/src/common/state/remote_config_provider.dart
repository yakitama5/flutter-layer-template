import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:infrastructure_firebase/src/common/enum/remote_configs.dart';
import 'package:riverpod/riverpod.dart';

/// Firebase Remote Config
/// テスト時にDIすることを考慮して、Providerとして定義
final remoteConfigProvider = FutureProvider<FirebaseRemoteConfig>((ref) async {
  final res = FirebaseRemoteConfig.instance;

  // キャッシュ化してないと利用できないようにする
  await res.fetchAndActivate();
  return res;
});

final stringConfigProvider = FutureProvider.autoDispose
    .family<String, RemoteConfigs<String>>((ref, config) async {
      final remoteConfig = await ref.watch(remoteConfigProvider.future);
      return remoteConfig.getString(config.key);
    });

final boolConfigProvider = FutureProvider.autoDispose
    .family<bool, RemoteConfigs<bool>>((ref, config) async {
      final remoteConfig = await ref.watch(remoteConfigProvider.future);
      return remoteConfig.getBool(config.key);
    });

final stringStreamConfigProvider = StreamProvider.autoDispose
    .family<String, RemoteConfigs<String>>((ref, config) async* {
      final remoteConfig = await ref.watch(remoteConfigProvider.future);

      // 初回は単純に取得
      final key = config.key;
      yield remoteConfig.getString(key);

      // キーが更新された際に最新の値を取得する
      yield* remoteConfig.onConfigUpdated
          .where((snapshot) => snapshot.updatedKeys.contains(key))
          .asyncMap((snapshot) async {
            await remoteConfig.activate();
            return remoteConfig.getString(key);
          });
    });

final boolStreamConfigProvider = StreamProvider.autoDispose
    .family<bool, RemoteConfigs<bool>>((ref, config) async* {
      final remoteConfig = await ref.watch(remoteConfigProvider.future);

      // 初回は単純に取得
      final key = config.key;
      yield remoteConfig.getBool(key);

      // キーが更新された際に最新の値を取得する
      yield* remoteConfig.onConfigUpdated
          .where((snapshot) => snapshot.updatedKeys.contains(key))
          .asyncMap((snapshot) async {
            await remoteConfig.activate();
            return remoteConfig.getBool(key);
          });
    });
