import 'package:domain/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:infrastructure_firebase/src/common/config/firebase_options.dart';
import 'package:infrastructure_firebase/src/common/config/firebase_options_dev.dart'
    as dev;

final class FirebaseInitializer {
  FirebaseInitializer._();

  static Future<void> initialize(Flavor flavor) async {
    // Flavor に応じた FirebaseOptions を準備する
    final firebaseOptions = switch (flavor) {
      Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
      Flavor.prd => DefaultFirebaseOptions.currentPlatform,
    };

    _validateNotDummyOptions(firebaseOptions);

    await Firebase.initializeApp(options: firebaseOptions);

    // Firebase Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// テンプレートのダミー値のまま起動しようとしていないかを検証する。
  ///
  /// `flutterfire configure` を未実施の状態で実行すると、作者の実Firebase
  /// プロジェクトへ誤って接続してしまう事故を防ぐためのガード。
  static void _validateNotDummyOptions(FirebaseOptions options) {
    if (options.projectId.startsWith('your-project-id')) {
      throw StateError(
        'Firebase設定がテンプレートのダミー値のままです。'
        'flutterfire configure を実行して自身のFirebaseプロジェクトの設定へ'
        '差し替えてください (docs/GET_STARTED.md 参照)',
      );
    }
  }
}
