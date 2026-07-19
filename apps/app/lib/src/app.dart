import 'package:designsystem/theme.dart';
import 'package:designsystem/widgets.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:flutter_app/src/debug/components/device_preview_wrapper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nested/nested.dart';

import 'router/state/go_router_provider.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // テーマ設定
    final themeMode = ref.watch(themeModeProvider);
    final lightTheme = ref.watch(appThemeProvider(Brightness.light));
    final darkTheme = ref.watch(appThemeProvider(Brightness.dark));

    return MaterialApp.router(
      builder: (_, child) => Nested(
        children: const [
          ResponsiveAutoScaleBox(),
          LoaderOverlay(),
          AppUpdateListener(),
          DevicePreviewSingleChildContainer(),
        ],
        child: child,
      ),

      // Slang
      locale:
          DevicePreview.locale(context) ??
          TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      scaffoldMessengerKey: SnackBarManager.rootScaffoldMessengerKey,
      routerConfig: ref.watch(goRouterProvider),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );
  }
}
