import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod/riverpod.dart';

/// Google Sign In
/// テスト時にDIすることを考慮して、Providerとして定義
final googleSignInProvider = Provider<GoogleSignIn>(
  (ref) => GoogleSignIn.instance,
);
