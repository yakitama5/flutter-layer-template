import 'package:version/version.dart';

abstract class AppVersionRepository {
  const AppVersionRepository();
  Stream<Version> listenLatestAppVersion();
  Stream<Version> listenForceUpdateAppVersion();
}
