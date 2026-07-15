import 'package:dependency_override/dependency_override.dart';
import 'package:designsystem/i18n.dart';
import 'package:device_preview/device_preview.dart';
import 'package:packages_application/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/router/routes/base_shell_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nested/nested.dart';

import 'app_initializer.dart';
import 'i18n/strings.g.dart';
import 'src/app.dart';
import 'src/router/state/initial_location_provider.dart';

void main() async {
  // アプリの初期処理
  WidgetsFlutterBinding.ensureInitialized();
  final (buildConfig: buildConfig) = await AppInitializer.initialize();
  LocaleSettings.useDeviceLocaleSync();

  // インフラ層の初期処理
  await InfrastructureInitializer.initialize(buildConfig.flavor);

  runApp(
    ProviderScope(
      overrides: [
        // インフラ層のDI
        ...await initializeInfrastructureProviders(),

        // アプリの初期設定
        appBuildConfigProvider.overrideWithValue(buildConfig),
        initialLocationProvider.overrideWithValue(RootRouteData.path),
      ],
      child: Nested(
        children: const [
          // Slangの伝播
          _AppTranslationProvider(),
          DesignsystemTranslationProvider(),

          // DevicePreview
          _DevicePreviewWrapper(),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class _AppTranslationProvider extends SingleChildStatelessWidget {
  const _AppTranslationProvider();

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      TranslationProvider(child: child ?? const SizedBox.shrink());
}

class _DevicePreviewWrapper extends SingleChildStatelessWidget {
  const _DevicePreviewWrapper();
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    const enableDevicePreview = bool.fromEnvironment('devicePreview');

    return DevicePreview(
      enabled: enableDevicePreview,
      builder: (context) => child ?? const SizedBox.shrink(),
    );
  }
}
