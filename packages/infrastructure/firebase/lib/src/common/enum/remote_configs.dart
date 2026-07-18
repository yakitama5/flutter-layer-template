import 'package:firebase_remote_config/firebase_remote_config.dart';

enum RemoteConfigs<T> {
  maintenance('app_maintenance_mode', false),
  latestAppVersion('latest_app_version', '0.0.0'),
  forceUpdateAppVersion('force_update_app_version', '0.0.0');

  const RemoteConfigs(this.key, this.defaultValue);

  final String key;
  final T defaultValue;

  /// Remote Configから現在の値を取得する
  T getValue(FirebaseRemoteConfig remoteConfig) => switch (this) {
    RemoteConfigs.maintenance => remoteConfig.getBool(key),
    RemoteConfigs.latestAppVersion ||
    RemoteConfigs.forceUpdateAppVersion => remoteConfig.getString(key),
  } as T;
}
