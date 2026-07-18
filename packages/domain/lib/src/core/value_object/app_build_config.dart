import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:version/version.dart';

import 'flavor.dart';

part 'app_build_config.freezed.dart';

/// アプリ共通の設定
@freezed
abstract class AppBuildConfig with _$AppBuildConfig {
  const factory AppBuildConfig({
    required Flavor flavor,
    required String appName,
    required String packageName,
    required Version version,
    required String buildNumber,
    required String buildSignature,
    String? installerStore,

    /// App Store Connectで発行される数値のApp Store ID
    ///
    /// ストア遷移(store_redirectのiOSAppId)で使用する。bundle IDではない点に注意。
    /// テンプレートの利用者は各flavorの設定ファイルに実際の値を設定すること。
    String? appStoreId,
  }) = _AppBuildConfig;
}
