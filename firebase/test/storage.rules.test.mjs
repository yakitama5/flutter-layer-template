import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, it } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  deleteObject,
  getBytes,
  ref,
  uploadBytes,
  uploadString,
} from 'firebase/storage';

const projectId = 'demo-flutter-layer-template';
let testEnv;

describe('Cloud Storage Security Rules', () => {
  before(async () => {
    testEnv = await initializeTestEnvironment({
      projectId,
      storage: {
        rules: readFileSync(
          new URL('../storage.rules', import.meta.url),
          'utf8',
        ),
      },
    });
  });

  beforeEach(() => testEnv.clearStorage());
  after(() => testEnv.cleanup());

  it('所有者の画像アップロードを許可する', async () => {
    const storage = testEnv.authenticatedContext('alice').storage();

    await assertSucceeds(
      uploadString(ref(storage, 'users/alice/avatar.png'), 'image', 'raw', {
        contentType: 'image/png',
      }),
    );
  });

  it('他ユーザーのpathへのアップロードを拒否する', async () => {
    const storage = testEnv.authenticatedContext('bob').storage();

    await assertFails(
      uploadString(ref(storage, 'users/alice/avatar.png'), 'image', 'raw', {
        contentType: 'image/png',
      }),
    );
  });

  it('画像以外のアップロードを拒否する', async () => {
    const storage = testEnv.authenticatedContext('alice').storage();

    await assertFails(
      uploadString(ref(storage, 'users/alice/profile.txt'), 'text', 'raw', {
        contentType: 'text/plain',
      }),
    );
  });

  it('10MB未満の画像アップロードを許可する', async () => {
    const storage = testEnv.authenticatedContext('alice').storage();
    const bytes = new Uint8Array(10 * 1024 * 1024 - 1);

    await assertSucceeds(
      uploadBytes(ref(storage, 'users/alice/avatar.png'), bytes, {
        contentType: 'image/png',
      }),
    );
  });

  it('10MB以上のアップロードを拒否する', async () => {
    const storage = testEnv.authenticatedContext('alice').storage();
    const bytes = new Uint8Array(10 * 1024 * 1024 + 1);

    await assertFails(
      uploadBytes(ref(storage, 'users/alice/avatar.png'), bytes, {
        contentType: 'image/png',
      }),
    );
  });

  it('contentTypeがimage/*でないアップロードを拒否する', async () => {
    const storage = testEnv.authenticatedContext('alice').storage();
    const bytes = new Uint8Array(10);

    await assertFails(
      uploadBytes(ref(storage, 'users/alice/document.pdf'), bytes, {
        contentType: 'application/pdf',
      }),
    );
  });

  it('所有者はファイルをreadできる', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await uploadString(
        ref(context.storage(), 'users/alice/avatar.png'),
        'image',
        'raw',
        { contentType: 'image/png' },
      );
    });
    const storage = testEnv.authenticatedContext('alice').storage();

    await assertSucceeds(getBytes(ref(storage, 'users/alice/avatar.png')));
  });

  it('所有者はファイルをdeleteできる', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await uploadString(
        ref(context.storage(), 'users/alice/avatar.png'),
        'image',
        'raw',
        { contentType: 'image/png' },
      );
    });
    const storage = testEnv.authenticatedContext('alice').storage();

    await assertSucceeds(deleteObject(ref(storage, 'users/alice/avatar.png')));
  });

  it('他ユーザーのpathのreadを拒否する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await uploadString(
        ref(context.storage(), 'users/alice/avatar.png'),
        'image',
        'raw',
        { contentType: 'image/png' },
      );
    });
    const storage = testEnv.authenticatedContext('bob').storage();

    await assertFails(getBytes(ref(storage, 'users/alice/avatar.png')));
  });

  it('未認証ユーザーのreadを拒否する', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await uploadString(
        ref(context.storage(), 'users/alice/avatar.png'),
        'image',
        'raw',
        { contentType: 'image/png' },
      );
    });
    const storage = testEnv.unauthenticatedContext().storage();

    await assertFails(getBytes(ref(storage, 'users/alice/avatar.png')));
  });

  it('未認証ユーザーのwriteを拒否する', async () => {
    const storage = testEnv.unauthenticatedContext().storage();

    await assertFails(
      uploadString(ref(storage, 'users/alice/avatar.png'), 'image', 'raw', {
        contentType: 'image/png',
      }),
    );
  });

  it('users以外のpathへの書き込みを拒否する', async () => {
    const storage = testEnv.authenticatedContext('alice').storage();

    await assertFails(
      uploadString(ref(storage, 'public/file.png'), 'image', 'raw', {
        contentType: 'image/png',
      }),
    );
  });
});
