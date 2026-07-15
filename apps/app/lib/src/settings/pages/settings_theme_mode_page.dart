import 'package:designsystem/i18n.dart';
import 'package:designsystem/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/src/settings_radio_list_tile.dart';
import '../components/src/settings_radio_scaffold.dart';

class SettingsThemeModePage extends HookConsumerWidget {
  const SettingsThemeModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialValue = ref.watch(themeModeProvider);
    final selected = useState<ThemeMode?>(initialValue);

    return SettingsRadioScaffold(
      title: i18n.settings.settingsPage.layout.themeMode,
      tiles: ThemeMode.values.map((themeMode) {
        return SettingsRadioListTile<ThemeMode>(
          title: Text(
            designsystemI18n.designsystem.themeMode(context: themeMode),
          ),
          value: themeMode,
          groupValue: selected.value,
          leading: Icon(switch (themeMode) {
            ThemeMode.system => Icons.settings,
            ThemeMode.light => Icons.light_mode,
            ThemeMode.dark => Icons.dark_mode,
          }),
          onChanged: (_) {
            selected.value = themeMode;
            ref.read(themeModeProvider.notifier).update(themeMode);
          },
        );
      }).toList(),
    );
  }
}
