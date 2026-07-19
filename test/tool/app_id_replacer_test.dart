import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../../tool/src/app_id_replacer.dart';

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('app_id_replacer_test_');
    await _createFixture(root);
  });

  tearDown(() => root.delete(recursive: true));

  test('AndroidとiOSの識別子を関連設定とともに置換する', () async {
    final result = await AppIdReplacer(
      rootDirectory: root,
    ).replace(appId: 'io.example.product');

    expect(result.changedPaths, contains('apps/app/flavor/prd.json'));
    expect(
      await _read(root, 'apps/app/flavor/dev.json'),
      contains('"appIdAndroid": "io.example.product"'),
    );
    expect(
      await _read(root, 'apps/app/pubspec.yaml'),
      contains('package_name: io.example.product.dev'),
    );
    expect(
      await _read(root, 'apps/app/integration_test/app_flow_test.dart'),
      contains("packageName: 'io.example.product.dev'"),
    );
    expect(
      await _read(root, 'apps/app/android/app/build.gradle'),
      contains('namespace = "io.example.product"'),
    );
    expect(
      File(
        '${root.path}/apps/app/android/app/src/main/kotlin/io/example/product/MainActivity.kt',
      ).readAsString(),
      completion(contains('package io.example.product')),
    );
    expect(
      File(
        '${root.path}/apps/app/android/app/src/main/kotlin/com/yakuran/flutter_app/MainActivity.kt',
      ).exists(),
      completion(isFalse),
    );

    final googleServices =
        jsonDecode(
              await _read(
                root,
                'apps/app/android/app/src/dev/google-services.json',
              ),
            )
            as Map<String, Object?>;
    final clients = googleServices['client']! as List<Object?>;
    expect(
      _jsonValuesForKey(clients, 'package_name'),
      containsAll(<String>['io.example.product', 'io.example.product.dev']),
    );
    expect(
      _jsonValuesForKey(clients, 'bundle_id'),
      everyElement(startsWith('io.example.product')),
    );
    expect(
      await _read(root, 'apps/app/ios/dev/GoogleService-Info.plist'),
      contains('<string>io.example.product.dev</string>'),
    );
    expect(
      await _read(
        root,
        'packages/infrastructure/firebase/lib/src/common/config/firebase_options.dart',
      ),
      contains("iosBundleId: 'io.example.product'"),
    );
  });

  test('dry-runでは変更内容だけを返してファイルを書き換えない', () async {
    final before = await _read(root, 'apps/app/flavor/prd.json');

    final result = await AppIdReplacer(
      rootDirectory: root,
    ).replace(appId: 'io.example.product', dryRun: true);

    expect(result.changedPaths, isNotEmpty);
    expect(await _read(root, 'apps/app/flavor/prd.json'), before);
    expect(
      File(
        '${root.path}/apps/app/android/app/src/main/kotlin/com/yakuran/flutter_app/MainActivity.kt',
      ).exists(),
      completion(isTrue),
    );
  });

  test('逆DNS形式でない識別子を拒否する', () async {
    expect(
      () => AppIdReplacer(rootDirectory: root).replace(appId: 'invalid-app-id'),
      throwsA(isA<FormatException>()),
    );
  });

  test('アンダースコアを含む識別子を拒否する（iOSバンドルIDと非互換）', () async {
    expect(
      () => AppIdReplacer(
        rootDirectory: root,
      ).replace(appId: 'io.example.my_app'),
      throwsA(isA<FormatException>()),
    );
  });

  test('置換対象のパターンが1件もヒットしない場合は例外を投げる（dry-runでも検出する）', () async {
    // pubspec.yaml の内容を期待パターンと一致しない内容へ書き換え、
    // 置換対象が見つからない状態を再現する。
    await _write(
      root,
      'apps/app/pubspec.yaml',
      'package_name: com.other.unrelated\n'
          'bundle_id: com.other.unrelated\n',
    );

    expect(
      () => AppIdReplacer(
        rootDirectory: root,
      ).replace(appId: 'io.example.product', dryRun: true),
      throwsA(isA<FormatException>()),
    );
  });

  test('GoogleService-Info.plistでパターンがヒットしない場合は例外を投げる', () async {
    await _write(
      root,
      'apps/app/ios/dev/GoogleService-Info.plist',
      '<string>com.other.unrelated</string>\n',
    );

    expect(
      () => AppIdReplacer(
        rootDirectory: root,
      ).replace(appId: 'io.example.product', dryRun: true),
      throwsA(isA<FormatException>()),
    );
  });

  test('google-services.jsonでpackage_name/bundle_idがヒットしない場合は例外を投げる', () async {
    final unrelated = <String, Object?>{
      'client': <Object?>[
        <String, Object?>{
          'client_info': <String, Object?>{
            'android_client_info': <String, Object?>{
              'package_name': 'com.other.unrelated',
            },
          },
          'oauth_client': <Object?>[
            <String, Object?>{
              'ios_info': <String, Object?>{'bundle_id': 'com.other.unrelated'},
            },
          ],
        },
      ],
    };
    await _writeJson(
      root,
      'apps/app/android/app/src/dev/google-services.json',
      unrelated,
    );

    expect(
      () => AppIdReplacer(
        rootDirectory: root,
      ).replace(appId: 'io.example.product', dryRun: true),
      throwsA(isA<FormatException>()),
    );
  });
}

Future<void> _createFixture(Directory root) async {
  await _writeJson(root, 'apps/app/flavor/dev.json', <String, Object?>{
    'flavor': 'dev',
    'appName': 'dev-Template',
    'appIdAndroid': 'com.yakuran.template',
    'appIdIos': 'com.yakuran.template',
    'appIdSuffix': '.dev',
  });
  await _writeJson(root, 'apps/app/flavor/prd.json', <String, Object?>{
    'flavor': 'prd',
    'appName': 'Template',
    'appIdAndroid': 'com.yakuran.template',
    'appIdIos': 'com.yakuran.template',
    'appIdSuffix': '',
  });
  await _write(
    root,
    'apps/app/pubspec.yaml',
    'package_name: com.yakuran.template.dev\n'
        'bundle_id: com.yakuran.template.dev\n',
  );
  await _write(
    root,
    'apps/app/integration_test/app_flow_test.dart',
    "packageName: 'com.yakuran.template.dev'\n",
  );
  await _write(
    root,
    'apps/app/android/app/build.gradle',
    'android {\n  namespace = "com.yakuran.flutter_app"\n}\n',
  );
  await _write(
    root,
    'apps/app/android/app/src/main/kotlin/com/yakuran/flutter_app/MainActivity.kt',
    'package com.yakuran.flutter_app\n\nclass MainActivity\n',
  );
  final googleServices = <String, Object?>{
    'client': <Object?>[
      <String, Object?>{
        'client_info': <String, Object?>{
          'android_client_info': <String, Object?>{
            'package_name': 'com.yakuran.template',
          },
        },
        'oauth_client': <Object?>[
          <String, Object?>{
            'ios_info': <String, Object?>{'bundle_id': 'com.yakuran.template'},
          },
        ],
      },
      <String, Object?>{
        'client_info': <String, Object?>{
          'android_client_info': <String, Object?>{
            'package_name': 'com.yakuran.template.dev',
          },
        },
      },
    ],
  };
  await _writeJson(
    root,
    'apps/app/android/app/src/dev/google-services.json',
    googleServices,
  );
  await _writeJson(
    root,
    'apps/app/android/app/src/prd/google-services.json',
    googleServices,
  );
  await _write(
    root,
    'apps/app/ios/dev/GoogleService-Info.plist',
    '<string>com.yakuran.template.dev</string>\n',
  );
  await _write(
    root,
    'apps/app/ios/prd/GoogleService-Info.plist',
    '<string>com.yakuran.template</string>\n',
  );
  await _write(
    root,
    'packages/infrastructure/firebase/lib/src/common/config/firebase_options.dart',
    "iosBundleId: 'com.yakuran.template'\n",
  );
  await _write(
    root,
    'packages/infrastructure/firebase/lib/src/common/config/firebase_options_dev.dart',
    "iosBundleId: 'com.yakuran.template.dev'\n",
  );
}

Future<void> _writeJson(
  Directory root,
  String relativePath,
  Map<String, Object?> value,
) => _write(
  root,
  relativePath,
  '${const JsonEncoder.withIndent('  ').convert(value)}\n',
);

Future<void> _write(Directory root, String relativePath, String content) async {
  final file = File('${root.path}/$relativePath');
  await file.parent.create(recursive: true);
  await file.writeAsString(content);
}

Future<String> _read(Directory root, String relativePath) =>
    File('${root.path}/$relativePath').readAsString();

List<String> _jsonValuesForKey(Object? value, String key) {
  final values = <String>[];
  if (value is Map<String, Object?>) {
    for (final entry in value.entries) {
      if (entry.key == key && entry.value is String) {
        values.add(entry.value! as String);
      }
      values.addAll(_jsonValuesForKey(entry.value, key));
    }
  } else if (value is List<Object?>) {
    for (final item in value) {
      values.addAll(_jsonValuesForKey(item, key));
    }
  }
  return values;
}
