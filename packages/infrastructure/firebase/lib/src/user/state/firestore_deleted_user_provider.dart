import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infrastructure_firebase/src/common/enum/firestore_columns.dart';
import 'package:infrastructure_firebase/src/common/extension/collection_reference.dart';
import 'package:infrastructure_firebase/src/common/state/firestore_provider.dart';
import 'package:infrastructure_firebase/src/user/model/firestore_user_model.dart';
import 'package:riverpod/riverpod.dart';

/// 削除済ユーザーコレクションの参照
final duserCollectionRefProvider =
    Provider.autoDispose<CollectionReference<FirestoreUserModel>>((ref) {
      return ref
          .watch(firestoreProvider)
          .dusersRef()
          .withConverter(
            fromFirestore: (snapshot, options) =>
                FirestoreUserModel.fromJson(snapshot.data()!),
            toFirestore: (value, options) => {
              ...value.toJson(),

              // 日付項目は自動更新
              FirestoreColumns.updatedAt.fieldName:
                  FieldValue.serverTimestamp(),
              if (value.createdAt == null)
                FirestoreColumns.createdAt.fieldName:
                    FieldValue.serverTimestamp(),
            },
          );
    });

/// 削除済ユーザードキュメントの参照
final duserDocumentRefProvider = Provider.autoDispose
    .family<DocumentReference<FirestoreUserModel>, String?>(
      (ref, userId) => ref.watch(duserCollectionRefProvider).doc(userId),
    );
