import 'package:designsystem/i18n.dart';
import 'package:designsystem/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:flutter_app/src/router/routes/branches/setting_shell_branch.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/src/themed_settings_list.dart';

abstract interface class SettingsPageNavigator {
  void goAccountPage(BuildContext context);
  void goUiStylePage(BuildContext context);
  void goThemeColorPage(BuildContext context);
  void goThemeModePage(BuildContext context);
  void goLicensePage(BuildContext context);
}

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在の設定値を取得
    final uiStyle = ref.watch(uiStyleProvider);
    final themeColor = ref.watch(themeColorProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(i18n.settings.settingsPage.title)),
      body: ThemedSettingsList(
        sections: [
          SettingsSection(
            title: Text(i18n.settings.settingsPage.account.head),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.link),
                title: Text(i18n.settings.settingsPage.account.account),
                onPressed: const SettingsAccountPageRouteData().go,
              ),
            ],
          ),
          SettingsSection(
            title: Text(i18n.settings.settingsPage.layout.head),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.style),
                title: Text(i18n.settings.settingsPage.layout.uiStyle),
                value: Text(
                  designsystemI18n.designsystem.uiStyle(context: uiStyle),
                ),
                onPressed: const SettingsUiStylePageRouteData().go,
              ),
              SettingsTile.navigation(
                // E2Eからタップ対象を一意に特定するためのKey
                key: const Key('settings_theme_mode_tile'),
                leading: Icon(switch (themeMode) {
                  ThemeMode.system => Icons.settings,
                  ThemeMode.light => Icons.light_mode,
                  ThemeMode.dark => Icons.dark_mode,
                }),
                title: Text(i18n.settings.settingsPage.layout.themeMode),
                value: Text(
                  designsystemI18n.designsystem.themeMode(context: themeMode),
                ),
                onPressed: const SettingsThemeModePageRouteData().go,
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.color_lens),
                title: Text(i18n.settings.settingsPage.layout.colorTheme),
                value: Text(
                  designsystemI18n.designsystem.themeColor(context: themeColor),
                ),
                onPressed: const SettingsThemeColorPageRouteData().go,
              ),
            ],
          ),
          SettingsSection(
            title: Text(i18n.settings.settingsPage.help.head),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.abc),
                title: Text(i18n.settings.settingsPage.help.howToUse),
                onPressed: _onHowToUse,
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.help),
                title: Text(i18n.settings.settingsPage.help.contactUs),
                onPressed: _onContactUs,
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.alternate_email),
                title: Text(i18n.settings.settingsPage.help.developerTwitter),
                onPressed: _onDeveloperTwitter,
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock),
                title: Text(i18n.settings.settingsPage.help.privacyPolicy),
                onPressed: _onPrivacyPolicy,
              ),
              SettingsTile.navigation(
                title: Text(i18n.settings.settingsPage.help.license),
                onPressed: const LicensePageRouteData().go,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onHowToUse(BuildContext context) {
    // TODO(yakitama5): Webページに遷移
  }

  void _onContactUs(BuildContext context) {
    // TODO(yakitama5): Webページに遷移
  }

  Future<void> _onDeveloperTwitter(BuildContext context) async {
    // TODO(yakitama5): Webページに遷移
  }

  Future<void> _onPrivacyPolicy(BuildContext context) async {
    // TODO(yakitama5): Webページに遷移
  }
}
