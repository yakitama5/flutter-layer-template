import 'package:designsystem/src/theme/model/dynamic_color_support_status.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import 'core_palette_provider.dart';

final dynamicColorSupportProvider =
    Provider.autoDispose<DynamicColorSupportStatus>((ref) {
      final corePalette = ref.watch(corePaletteProvider).value;
      final isSupport =
          corePalette != null &&
          switch (defaultTargetPlatform) {
            TargetPlatform.iOS || TargetPlatform.macOS => false,
            _ => true,
          };

      return isSupport
          ? DynamicColorSupportStatus.supported
          : DynamicColorSupportStatus.notSupported;
    });
