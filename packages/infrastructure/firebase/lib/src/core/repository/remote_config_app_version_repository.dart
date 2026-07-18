import 'package:domain/core.dart';
import 'package:domain/util.dart';
import 'package:infrastructure_firebase/src/common/enum/remote_configs.dart';
import 'package:infrastructure_firebase/src/common/state/remote_config_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:version/version.dart';

class RemoteConfigAppVersionRepository extends AppVersionRepository {
  const RemoteConfigAppVersionRepository(this.ref);

  final Ref ref;

  @override
  Stream<Version> listenForceUpdateAppVersion() =>
      _listenVersion(RemoteConfigs.forceUpdateAppVersion);

  @override
  Stream<Version> listenLatestAppVersion() =>
      _listenVersion(RemoteConfigs.latestAppVersion);

  /// バージョンを取得する
  Stream<Version> _listenVersion(RemoteConfigs<String> config) async* {
    final remoteConfig = await ref.read(remoteConfigProvider.future);
    yield* listenConfigValue(remoteConfig, config).map((value) {
      try {
        return Version.parse(value);
      } on FormatException {
        // 不正な値が配信された場合はデフォルト値にフォールバックし、ストリームを継続させる
        logger.w(
          'Remote Configのバージョン値が不正なためデフォルト値を使用します: '
          'key=${config.key}, value=$value',
        );
        return Version.parse(config.defaultValue);
      }
    });
  }
}
