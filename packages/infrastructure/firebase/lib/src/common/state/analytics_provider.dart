import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod/riverpod.dart';

/// Firebase Analytics
/// テスト時にDIすることを考慮して、Providerとして定義
final analyticsProvider = Provider<FirebaseAnalytics>(
  (ref) => FirebaseAnalytics.instance,
);
