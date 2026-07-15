abstract class AppMaintenanceRepository {
  const AppMaintenanceRepository();
  Future<bool> fetchMaintenanceMode();
  Stream<bool> listenMaintenanceMode();
}
