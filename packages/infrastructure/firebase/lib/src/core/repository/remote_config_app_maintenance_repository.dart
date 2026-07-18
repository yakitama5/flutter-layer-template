import 'package:domain/core.dart';
import 'package:infrastructure_firebase/src/common/enum/remote_configs.dart';
import 'package:infrastructure_firebase/src/common/state/remote_config_provider.dart';
import 'package:riverpod/riverpod.dart';

class RemoteConfigAppMaintenanceRepository extends AppMaintenanceRepository {
  const RemoteConfigAppMaintenanceRepository(this.ref);

  final Ref ref;

  @override
  Future<bool> fetchMaintenanceMode() async {
    final remoteConfig = await ref.read(remoteConfigProvider.future);
    return RemoteConfigs.maintenance.getValue(remoteConfig);
  }

  @override
  Stream<bool> listenMaintenanceMode() async* {
    final remoteConfig = await ref.read(remoteConfigProvider.future);
    yield* listenConfigValue(remoteConfig, RemoteConfigs.maintenance);
  }
}
