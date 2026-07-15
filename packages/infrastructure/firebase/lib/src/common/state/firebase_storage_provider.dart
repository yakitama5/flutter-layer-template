import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod/riverpod.dart';

/// Firebase Storage
/// テスト時にDIすることを考慮して、Providerとして定義
final firebaseStorageProvider = Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instance,
);
