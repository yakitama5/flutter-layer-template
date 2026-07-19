import 'package:domain/core.dart';
import 'package:domain/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:infrastructure_firebase/src/common/extension/firebase_auth_user_extension.dart';
import 'package:infrastructure_firebase/src/common/state/firebase_auth_provider.dart';
import 'package:infrastructure_firebase/src/common/state/firestore_provider.dart';
import 'package:infrastructure_firebase/src/common/state/google_sign_in_provider.dart';
import 'package:infrastructure_firebase/src/common/util/firebase_exception_handler.dart';
import 'package:infrastructure_firebase/src/user/model/firestore_user_model.dart';
import 'package:infrastructure_firebase/src/user/state/firestore_deleted_user_provider.dart';
import 'package:infrastructure_firebase/src/user/state/firestore_user_provider.dart';
import 'package:riverpod/riverpod.dart';

/// Firebaseを利用したリポジトリの実装
class FirebaseUserRepository implements UserRepository {
  const FirebaseUserRepository(this.ref);

  final Ref ref;

  /// 認証ユーザー
  ///
  /// Note: トランザクションコールバック等のbuild外でも呼び出されるため`ref.read`を使用する。
  auth.User? get _currentUser => ref.read(firebaseAuthProvider).currentUser;

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
  Future<void> signUp() {
    return guardFirebaseException(() async {
      // 認証 (すでに認証だけしていたらIDの取得だけ)
      final authUid = await _authSignUp();

      // ドキュメントが存在しなければ登録
      await _createUserDocIfNotExists(authUid);
    });
  }

  @override
  Future<void> delete({required String userId}) {
    return guardFirebaseException(() async {
      // ユーザーモデルの削除
      final firestore = ref.read(firestoreProvider);
      await firestore.runTransaction((transaction) async {
        // 削除前の状態を保持
        final docRef = ref.read(userDocumentRefProvider(userId));
        final delDocRef = ref.read(duserDocumentRefProvider(userId));
        final doc = await transaction.get(docRef);
        final data = doc.data();

        // ドキュメントの削除
        transaction.delete(docRef);

        // 削除前のデータが存在する場合のみ、削除用ドキュメントへ退避する
        // (usersドキュメント未作成のまま削除された場合はスキップし、べき等に動作させる)
        if (data != null) {
          transaction.set<FirestoreUserModel>(delDocRef, data);
        }
      });

      // 認証情報の削除
      //
      // Note: 直近のサインインから時間が経過している場合、Firebaseは
      // `requires-recent-login`を返す。この例外は`guardFirebaseException`により
      // `RequiresRecentLoginException`へ変換される。UIは再認証後に再度`delete`を
      // 呼び出すことで、残った認証情報を削除できる。Firestoreドキュメントは
      // 既に削除済みでもべき等に動作するため、再実行しても問題ない。
      await ref.read(firebaseAuthProvider).currentUser?.delete();
    });
  }

  @override
  Stream<AuthStatus?> listenAuthStatus() {
    return ref.read(firebaseAuthProvider).userChanges().map((authUser) {
      if (authUser == null) {
        return null;
      }
      return authUser.authStatus;
    });
  }

  @override
  Future<AuthStatus> signInAnonymously() {
    return guardFirebaseException(() async {
      // 匿名ログイン
      final credential = await ref
          .read(firebaseAuthProvider)
          .signInAnonymously();

      // 結果を変換
      final user = credential.user;
      if (user == null) {
        throw const SignInFailedException();
      }
      return user.authStatus;
    });
  }

  @override
  Future<AuthStatus> signInWithApple() {
    return guardFirebaseException(() async {
      // プラットフォームに応じた認証
      final credential = await (kIsWeb
          ? _signInWithAppleByWeb()
          : _signInWithAppleByMobile());

      // 認証結果を確認
      final authUser = credential.user;
      if (authUser == null) {
        throw const SignInFailedException();
      }

      // ドキュメントが存在しなければ登録
      await _createUserDocIfNotExists(authUser.uid);

      // 変換して返却
      return authUser.authStatus;
    });
  }

  @override
  Future<AuthStatus> signInWithGoogle() {
    return guardFirebaseException(() async {
      final credential = await (kIsWeb
          ? _signInWithGoogleByWeb()
          : _signInWithGoogleByMobile());

      // 認証結果を確認
      final authUser = credential.user;
      if (authUser == null) {
        throw const SignInFailedException();
      }

      // ドキュメントが存在しなければ登録
      await _createUserDocIfNotExists(authUser.uid);

      return authUser.authStatus;
    });
  }

  @override
  Future<void> signOut() {
    return guardFirebaseException(() {
      return ref.read(firebaseAuthProvider).signOut();
    });
  }

  @override
  Future<void> unlinkWithApple() {
    return guardFirebaseException(() async {
      await _currentUser?.unlink(auth.AppleAuthProvider.PROVIDER_ID);
    });
  }

  @override
  Future<void> unlinkWithGoogle() {
    return guardFirebaseException(() async {
      await _currentUser?.unlink(auth.GoogleAuthProvider.PROVIDER_ID);
    });
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
    final firebaseAuth = ref.read(firebaseAuthProvider);
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
    final firebaseAuth = ref.read(firebaseAuthProvider);
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
    final googleSignIn = await ref.read(googleSignInInitializedProvider.future);
    final account = await googleSignIn.authenticate();

    final credential = auth.GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );

    // 現在のユーザー情報があれば連携する
    final current = _currentUser;
    if (current != null) {
      return current.linkWithCredential(credential);
    } else {
      return ref.read(firebaseAuthProvider).signInWithCredential(credential);
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
      return ref.read(firebaseAuthProvider).signInWithPopup(googleProvider);
    }
  }

  Future<void> _createUserDocIfNotExists(String uid) async {
    // ドキュメントの取得
    final userDocRef = ref.read(userDocumentRefProvider(uid));
    final userDoc = await userDocRef.get();

    // 存在すれば認証情報を返却して終了
    if (userDoc.exists) {
      return;
    }

    // Firestore用のモデルに変換
    final userId = userDocRef.id;
    final user = FirestoreUserModel(id: userId);

    // 同時に登録
    await ref.read(firestoreProvider).runTransaction((transaction) async {
      return transaction.set(userDocRef, user);
    });
  }
}
