// ignore_for_file: deprecated_member_use

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:material_color_utilities/palettes/core_palette.dart';
import 'package:riverpod/riverpod.dart';

final corePaletteProvider = FutureProvider.autoDispose<CorePalette?>((
  ref,
) async {
  // 未対応のWebでは取得処理を呼び出さない
  if (kIsWeb) {
    return null;
  }

  return DynamicColorPlugin.getCorePalette();
});
