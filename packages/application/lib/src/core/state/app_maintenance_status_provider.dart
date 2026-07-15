import 'package:domain/core.dart';
import 'package:riverpod/riverpod.dart';

import '../interface/app_maintenance_repository.dart';

final appMaintenanceStatusProvider = StreamProvider<AppMaintenanceStatus>((
  ref,
) {
  final repository = ref.watch(appMaintenanceRepositoryProvider);
  return repository.listenMaintenanceMode().map(
    (isMaintenance) => isMaintenance
        ? AppMaintenanceStatus.maintenance
        : AppMaintenanceStatus.none,
  );
});
