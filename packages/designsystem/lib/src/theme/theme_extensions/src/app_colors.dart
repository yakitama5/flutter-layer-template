import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_colors.tailor.dart';

@TailorMixin()
class AppColors extends ThemeExtension<AppColors> with _$AppColorsTailorMixin {
  const AppColors({required this.favIcon});

  factory AppColors.brightness({required Brightness brightness}) =>
      switch (brightness) {
        Brightness.light => const AppColors(favIcon: Colors.blueAccent),
        Brightness.dark => const AppColors(favIcon: Colors.lightBlue),
      };

  @override
  final Color favIcon;
}
