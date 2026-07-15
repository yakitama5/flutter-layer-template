import 'package:riverpod/riverpod.dart';

import '../enum/preferences.dart';
import 'shared_preferences_provider.dart';

///
/// shared_preferencesへの値の出し入れを管理するためのプロバイダー.
/// `Preference<String>`のenum値を設定して利用する.
///
final stringPreferenceProvider = NotifierProvider.autoDispose
    .family<StringPreference, String, Preferences<String>>(
      StringPreference.new,
    );

class StringPreference extends Notifier<String> {
  StringPreference(this.pref);

  final Preferences<String> pref;

  @override
  String build() =>
      ref.read(sharedPreferencesProvider).getString(pref.key) ??
      pref.defaultValue;

  /// ローカルストレージ値の更新
  Future<void> update(String value) async {
    await ref.read(sharedPreferencesProvider).setString(pref.key, value);
    ref.invalidateSelf();
  }
}

///
/// shared_preferencesへの値の出し入れを管理するためのプロバイダー.
/// `Preference<bool>`のenum値を設定して利用する.
///
final boolPreferenceProvider = NotifierProvider.autoDispose
    .family<BoolPreference, bool, Preferences<bool>>(BoolPreference.new);

class BoolPreference extends Notifier<bool> {
  BoolPreference(this.pref);

  final Preferences<bool> pref;

  @override
  bool build() =>
      ref.read(sharedPreferencesProvider).getBool(pref.key) ??
      pref.defaultValue;

  /// ローカルストレージ値の更新
  // ignore: avoid_positional_boolean_parameters
  Future<void> update(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(pref.key, value);
    ref.invalidateSelf();
  }
}

///
/// shared_preferencesへの値の出し入れを管理するためのプロバイダー.
/// `Preference<int>`のenum値を設定して利用する.
///
final intPreferenceProvider = NotifierProvider.autoDispose
    .family<IntPreference, int, Preferences<int>>(IntPreference.new);

class IntPreference extends Notifier<int> {
  IntPreference(this.pref);

  final Preferences<int> pref;

  @override
  int build() =>
      ref.read(sharedPreferencesProvider).getInt(pref.key) ?? pref.defaultValue;

  /// ローカルストレージ値の更新
  Future<void> update(int value) async {
    await ref.read(sharedPreferencesProvider).setInt(pref.key, value);
    ref.invalidateSelf();
  }
}
