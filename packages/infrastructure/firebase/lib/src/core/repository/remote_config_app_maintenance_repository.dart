import 'package:domain/core.dart';
import 'package:infrastructure_firebase/src/common/enum/remote_configs.dart';
import 'package:infrastructure_firebase/src/common/state/remote_config_provider.dart';
import 'package:riverpod/riverpod.dart';

class RemoteConfigAppMaintenanceRepository extends AppMaintenanceRepository {
  const RemoteConfigAppMaintenanceRepository(this.ref);

  final Ref ref;

  @override
  Future<bool> fetchMaintenanceMode() async {
    final remoteConfig = await ref.watch(remoteConfigProvider.future);
    return remoteConfig.getBool(RemoteConfigs.maintenance.key);
  }

  @override
  Stream<bool> listenMaintenanceMode() async* {
    final value = await ref.watch(
      boolStreamConfigProvider(RemoteConfigs.maintenance).future,
    );
    yield value;
  }
}
