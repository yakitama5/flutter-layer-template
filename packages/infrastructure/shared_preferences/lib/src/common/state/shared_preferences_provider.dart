import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreference
/// テスト時にDIすることを考慮して、Providerとして定義
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) =>
      // アプリ起動時 or テスト時に `override` することを前提に利用
      throw UnimplementedError(),
);
