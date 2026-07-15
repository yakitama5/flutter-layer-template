import 'dart:async';

import 'package:packages_application/core.dart';
import 'package:domain/util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

typedef InitializedValues = ({AppBuildConfig buildConfig});

final class AppInitializer {
  AppInitializer._();

  static Future<InitializedValues> initialize() async {
    final buildConfig = await _initializeBuildConfig();

    logger.i(buildConfig);
    return (buildConfig: buildConfig);
  }

  static Future<AppBuildConfig> _initializeBuildConfig() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return AppBuildConfig(
      flavor: Flavor.values.byName(const String.fromEnvironment('flavor')),
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: Version.parse(packageInfo.version),
      buildNumber: packageInfo.buildNumber,
      buildSignature: packageInfo.buildSignature,
      installerStore: packageInfo.installerStore,
    );
  }
}
