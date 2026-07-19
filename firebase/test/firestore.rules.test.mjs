import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, it } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  runTransaction,
  serverTimestamp,
  setDoc,
  Timestamp,
  updateDoc,
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

  it('他ユーザーのドキュメント取得を拒否する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), 'users/alice'),
        validUser('alice'),
      );
    });
    const firestore = testEnv.authenticatedContext('bob').firestore();

    await assertFails(getDoc(doc(firestore, 'users/alice')));
  });

  it('usersコレクションのlistを所有者でも拒否する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), 'users/alice'),
        validUser('alice'),
      );
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(getDocs(collection(firestore, 'users')));
  });

  it('所有者はschemaに準拠したユーザードキュメントをupdateできる', async () => {
    const createdAt = Timestamp.now();
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(doc(context.firestore(), 'users/alice'), {
        id: 'alice',
        created_at: createdAt,
        updated_at: createdAt,
      });
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertSucceeds(
      updateDoc(doc(firestore, 'users/alice'), {
        id: 'alice',
        created_at: createdAt,
        updated_at: serverTimestamp(),
      }),
    );
  });

  it('created_atを改ざんするupdateを拒否する', async () => {
    const createdAt = Timestamp.now();
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(doc(context.firestore(), 'users/alice'), {
        id: 'alice',
        created_at: createdAt,
        updated_at: createdAt,
      });
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(
      updateDoc(doc(firestore, 'users/alice'), {
        id: 'alice',
        created_at: Timestamp.fromMillis(createdAt.toMillis() + 1000),
        updated_at: serverTimestamp(),
      }),
    );
  });

  it('updated_atがrequest.timeでないupdateを拒否する', async () => {
    const createdAt = Timestamp.now();
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(doc(context.firestore(), 'users/alice'), {
        id: 'alice',
        created_at: createdAt,
        updated_at: createdAt,
      });
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(
      updateDoc(doc(firestore, 'users/alice'), {
        id: 'alice',
        created_at: createdAt,
        updated_at: Timestamp.now(),
      }),
    );
  });

  it('スキーマ外フィールドを追加するupdateを拒否する', async () => {
    const createdAt = Timestamp.now();
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(doc(context.firestore(), 'users/alice'), {
        id: 'alice',
        created_at: createdAt,
        updated_at: createdAt,
      });
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(
      updateDoc(doc(firestore, 'users/alice'), {
        id: 'alice',
        created_at: createdAt,
        updated_at: serverTimestamp(),
        role: 'admin',
      }),
    );
  });

  it('他ユーザーのドキュメントのupdateを拒否する', async () => {
    const createdAt = Timestamp.now();
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(doc(context.firestore(), 'users/alice'), {
        id: 'alice',
        created_at: createdAt,
        updated_at: createdAt,
      });
    });
    const firestore = testEnv.authenticatedContext('bob').firestore();

    await assertFails(
      updateDoc(doc(firestore, 'users/alice'), {
        id: 'alice',
        created_at: createdAt,
        updated_at: serverTimestamp(),
      }),
    );
  });

  it('所有者であっても_dusersのupdateを拒否する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), '_dusers/alice'),
        validUser('alice'),
      );
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(
      updateDoc(doc(firestore, '_dusers/alice'), {
        id: 'alice',
        created_at: Timestamp.now(),
        updated_at: serverTimestamp(),
      }),
    );
  });

  it('所有者であっても_dusersのdeleteを拒否する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), '_dusers/alice'),
        validUser('alice'),
      );
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(deleteDoc(doc(firestore, '_dusers/alice')));
  });

  it('所有者であっても_dusersのgetを拒否する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), '_dusers/alice'),
        validUser('alice'),
      );
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(getDoc(doc(firestore, '_dusers/alice')));
  });

  it('users/_dusers以外の任意パスへの書き込みを拒否する', async () => {
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(
      setDoc(doc(firestore, 'other/doc'), { foo: 'bar' }),
    );
  });

  it('users/_dusers以外の任意パスへの読み取りを拒否する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(doc(context.firestore(), 'other/doc'), { foo: 'bar' });
    });
    const firestore = testEnv.authenticatedContext('alice').firestore();

    await assertFails(getDoc(doc(firestore, 'other/doc')));
  });
});

function validUser(userId) {
  return {
    id: userId,
    created_at: serverTimestamp(),
    updated_at: serverTimestamp(),
  };
}
