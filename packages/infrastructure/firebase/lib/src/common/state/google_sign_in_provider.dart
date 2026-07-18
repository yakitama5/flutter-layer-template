import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod/riverpod.dart';

/// Google Sign In
/// テスト時にDIすることを考慮して、Providerとして定義
final googleSignInProvider = Provider<GoogleSignIn>(
  (ref) => GoogleSignIn.instance,
);

/// 初期化済みのGoogle Sign Inインスタンス
///
/// google_sign_in v7では authenticate() の前に initialize() の完了が必須。
/// FutureProviderのキャッシュにより初期化は一度だけ実行される。
final googleSignInInitializedProvider = FutureProvider<GoogleSignIn>((
  ref,
) async {
  final googleSignIn = ref.watch(googleSignInProvider);
  // Androidでは serverClientId が必要な場合がある。
  // google-services.json に oauth_client が定義されていれば
  // リソース(default_web_client_id)から自動解決される。
  await googleSignIn.initialize();
  return googleSignIn;
});
