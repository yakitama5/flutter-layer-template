import { readFile } from 'node:fs/promises';
import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

describe('Remote Config template', () => {
  it('アプリが参照するparameterと型を定義する', async () => {
    const template = JSON.parse(
      await readFile(
        new URL('../remoteconfig.template.json', import.meta.url),
        'utf8',
      ),
    );

    assert.deepEqual(Object.keys(template.parameters).sort(), [
      'app_maintenance_mode',
      'force_update_app_version',
      'latest_app_version',
    ]);
    assert.deepEqual(
      parameterDefinition(template, 'app_maintenance_mode'),
      { defaultValue: 'false', valueType: 'BOOLEAN' },
    );
    assert.deepEqual(
      parameterDefinition(template, 'latest_app_version'),
      { defaultValue: '0.0.0', valueType: 'STRING' },
    );
    assert.deepEqual(
      parameterDefinition(template, 'force_update_app_version'),
      { defaultValue: '0.0.0', valueType: 'STRING' },
    );
  });
});

function parameterDefinition(template, key) {
  const parameter = template.parameters[key];
  return {
    defaultValue: parameter.defaultValue.value,
    valueType: parameter.valueType,
  };
}
