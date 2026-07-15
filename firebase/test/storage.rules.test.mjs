import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, it } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import { ref, uploadString } from 'firebase/storage';

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
});
