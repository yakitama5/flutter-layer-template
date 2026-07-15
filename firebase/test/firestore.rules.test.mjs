import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, it } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  deleteDoc,
  doc,
  getDoc,
  runTransaction,
  serverTimestamp,
  setDoc,
  Timestamp,
} from 'firebase/firestore';

const projectId = 'demo-flutter-layer-template';
let testEnv;

describe('Cloud Firestore Security Rules', () => {
  before(async () => {
    testEnv = await initializeTestEnvironment({
      projectId,
      firestore: {
        rules: readFileSync(
          new URL('../firestore.rules', import.meta.url),
          'utf8',
        ),
      },
    });
  });

  beforeEach(() => testEnv.clearFirestore());
  after(() => testEnv.cleanup());

  it('未認証ユーザーの読み書きを拒否する', async () => {
    const firestore = testEnv.unauthenticatedContext().firestore();

    await assertFails(getDoc(doc(firestore, 'users/alice')));
    await assertFails(
      setDoc(doc(firestore, 'users/alice'), validUser('alice')),
    );
  });

  it('所有者だけが正しいschemaのユーザードキュメントを作成・参照できる', async () => {
    const alice = testEnv.authenticatedContext('alice').firestore();
    const bob = testEnv.authenticatedContext('bob').firestore();
    const user = doc(alice, 'users/alice');

    await assertSucceeds(setDoc(user, validUser('alice')));
    await assertSucceeds(getDoc(user));
    await assertFails(getDoc(doc(bob, 'users/alice')));
  });

  it('不正なfieldを持つユーザードキュメントを拒否する', async () => {
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(
      setDoc(doc(firestore, 'users/alice'), {
        ...validUser('alice'),
        role: 'admin',
      }),
    );
  });

  it('所有者による退会トランザクションだけを許可する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(doc(context.firestore(), 'users/alice'), {
        id: 'alice',
        created_at: Timestamp.now(),
        updated_at: Timestamp.now(),
      });
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();
    const user = doc(firestore, 'users/alice');
    const deletedUser = doc(firestore, '_dusers/alice');

    await assertSucceeds(
      runTransaction(firestore, async (transaction) => {
        const snapshot = await transaction.get(user);
        transaction.delete(user);
        transaction.set(deletedUser, {
          ...snapshot.data(),
          updated_at: serverTimestamp(),
        });
      }),
    );
    await assertFails(getDoc(deletedUser));
  });

  it('他ユーザーのドキュメント削除を拒否する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), 'users/alice'),
        validUser('alice'),
      );
    });
    const firestore = testEnv.authenticatedContext('bob').firestore();

    await assertFails(deleteDoc(doc(firestore, 'users/alice')));
  });
});

function validUser(userId) {
  return {
    id: userId,
    created_at: serverTimestamp(),
    updated_at: serverTimestamp(),
  };
}
