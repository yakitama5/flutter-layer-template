import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

/// Firestore
/// テスト時にDIすることを考慮して、Providerとして定義
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);
