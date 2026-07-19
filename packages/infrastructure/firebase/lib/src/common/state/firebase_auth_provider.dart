import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

/// Firebase Auth
/// テスト時にDIすることを考慮して、Providerとして定義
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);
