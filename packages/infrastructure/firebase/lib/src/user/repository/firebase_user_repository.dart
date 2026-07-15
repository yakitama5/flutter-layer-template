import 'package:domain/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:infrastructure_firebase/src/common/extension/firebase_auth_user_extension.dart';
import 'package:infrastructure_firebase/src/common/state/firebase_auth_provider.dart';
import 'package:infrastructure_firebase/src/common/state/firestore_provider.dart';
import 'package:infrastructure_firebase/src/common/state/google_sign_in_provider.dart';
import 'package:infrastructure_firebase/src/user/model/firestore_user_model.dart';
import 'package:infrastructure_firebase/src/user/state/firestore_deleted_user_provider.dart';
import 'package:infrastructure_firebase/src/user/state/firestore_user_provider.dart';
import 'package:riverpod/riverpod.dart';

/// Firebaseを利用したリポジトリの実装
class FirebaseUserRepository implements UserRepository {
  const FirebaseUserRepository(this.ref);

  final Ref ref;

  /// 認証ユーザー
  auth.User? get _currentUser => ref.watch(firebaseAuthProvider).currentUser;

  @override
  Stream<User?> listen({required String userId}) {
    return ref
        .read(userDocumentRefProvider(userId))
        .snapshots()
        .where((s) {
          // 読み込み中のドキュメントが存在する場合はスキップ
          final doc = s.data();
          return doc == null || !doc.fieldValuePending;
        })
        .map((snap) => snap.data()?.toDomainModel());
  }

  @override
  Future<void> signUp() async {
    // 認証 (すでに認証だけしていたらIDの取得だけ)
    final authUid = await _authSignUp();

    // ドキュメントが存在しなければ登録
    await _createUserDocIfNotExists(authUid);
  }

  @override
  Future<void> delete({required String userId}) async {
    // ユーザーモデルの削除
    final firestore = ref.watch(firestoreProvider);
    await firestore.runTransaction((transaction) async {
      // 削除前の状態を保持
      final docRef = ref.watch(userDocumentRefProvider(userId));
      final delDocRef = ref.watch(duserDocumentRefProvider(userId));
      final doc = await transaction.get(docRef);

      transaction
          // ドキュメントの削除
          .delete(docRef)
          // 削除用ドキュメントの追加
          .set<FirestoreUserModel>(delDocRef, doc.data()!);
    });

    // 認証情報の削除
    await ref.watch(firebaseAuthProvider).currentUser?.delete();
  }

  @override
  Stream<AuthStatus?> listenAuthStatus() {
    return ref.watch(firebaseAuthProvider).userChanges().map((authUser) {
      if (authUser == null) {
        return null;
      }
      return authUser.authStatus;
    });
  }

  @override
  Future<AuthStatus> signInAnonymously() async {
    // 匿名ログイン
    final credential = await ref
        .watch(firebaseAuthProvider)
        .signInAnonymously();

    // 結果を変換
    return credential.user!.authStatus;
  }

  @override
  Future<AuthStatus> signInWithApple() async {
    // プラットフォームに応じた認証
    final credential = await (kIsWeb
        ? _signInWithAppleByWeb()
        : _signInWithAppleByMobile());

    // ドキュメントが存在しなければ登録
    final authUser = credential.user!;
    await _createUserDocIfNotExists(authUser.uid);

    // 変換して返却
    return credential.user!.authStatus;
  }

  @override
  Future<AuthStatus> signInWithGoogle() async {
    final credential = await (kIsWeb
        ? _signInWithGoogleByWeb()
        : _signInWithGoogleByMobile());

    // ドキュメントが存在しなければ登録
    final authUser = credential.user!;
    await _createUserDocIfNotExists(authUser.uid);

    return authUser.authStatus;
  }

  @override
  Future<void> signOut() {
    return ref.watch(firebaseAuthProvider).signOut();
  }

  @override
  Future<void> unlinkWithApple() async {
    await _currentUser?.unlink(auth.AppleAuthProvider.PROVIDER_ID);
  }

  @override
  Future<void> unlinkWithGoogle() async {
    await _currentUser?.unlink(auth.GoogleAuthProvider.PROVIDER_ID);
  }

  /// 認証状態に関するSignUp処理
  Future<String> _authSignUp() async {
    // 認証済の場合は現在の認証情報を返して終わり
    final currentUser = _currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    }

    // 未認証の場合は匿名ログインを行う
    final user = await signInAnonymously();
    return user.uid;
  }

  /// モバイル用のAppleサインイン
  Future<auth.UserCredential> _signInWithAppleByMobile() {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final appleProvider = auth.AppleAuthProvider();
    final current = _currentUser;

    // 新規か既存アカウント連携の判定を行う
    if (current != null) {
      return current.linkWithProvider(appleProvider);
    } else {
      return firebaseAuth.signInWithProvider(appleProvider);
    }
  }

  /// Web用のAppleサインイン
  Future<auth.UserCredential> _signInWithAppleByWeb() {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final appleProvider = auth.AppleAuthProvider();
    final current = _currentUser;

    // 新規か既存アカウント連携の判定を行う
    if (current != null) {
      return current.linkWithPopup(appleProvider);
    } else {
      return firebaseAuth.signInWithPopup(appleProvider);
    }
  }

  /// Mobile用のGoogleサインイン
  Future<auth.UserCredential> _signInWithGoogleByMobile() async {
    final googleSignIn = ref.read(googleSignInProvider);
    final account = await googleSignIn.authenticate();

    final credential = auth.GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );

    // 現在のユーザー情報があれば連携する
    final current = _currentUser;
    if (current != null) {
      return current.linkWithCredential(credential);
    } else {
      return ref.watch(firebaseAuthProvider).signInWithCredential(credential);
    }
  }

  /// Web用のGoogleサインイン
  Future<auth.UserCredential> _signInWithGoogleByWeb() async {
    // 必要な権限に応じて設定
    // Notes: https://developers.google.com/identity/protocols/oauth2/scopes?hl=ja#people
    final googleProvider = auth.GoogleAuthProvider();

    // 現在のユーザー情報があれば連携する
    final current = _currentUser;
    if (current != null) {
      return current.linkWithPopup(googleProvider);
    } else {
      return ref.watch(firebaseAuthProvider).signInWithPopup(googleProvider);
    }
  }

  Future<void> _createUserDocIfNotExists(String uid) async {
    // ドキュメントの取得
    final userDocRef = ref.watch(userDocumentRefProvider(uid));
    final userDoc = await userDocRef.get();

    // 存在すれば認証情報を返却して終了
    if (userDoc.exists) {
      return;
    }

    // Firestore用のモデルに変換
    final userId = userDocRef.id;
    final user = FirestoreUserModel(id: userId);

    // 同時に登録
    await ref.watch(firestoreProvider).runTransaction((transaction) async {
      return transaction.set(userDocRef, user);
    });
  }
}
