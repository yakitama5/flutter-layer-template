import 'dart:convert';
import 'dart:io';

final class AppIdReplacementResult {
  const AppIdReplacementResult(this.changedPaths);

  final List<String> changedPaths;
}

final class AppIdReplacer {
  AppIdReplacer({required this.rootDirectory});

  final Directory rootDirectory;

  Future<AppIdReplacementResult> replace({
    required String appId,
    bool dryRun = false,
  }) async {
    _validateAppId(appId);

    final devFlavorFile = _file('apps/app/flavor/dev.json');
    final prdFlavorFile = _file('apps/app/flavor/prd.json');
    final devFlavor = await _readJsonObject(devFlavorFile);
    final prdFlavor = await _readJsonObject(prdFlavorFile);
    final oldAndroidAppId = _requiredString(prdFlavor, 'appIdAndroid');
    final oldIosBundleId = _requiredString(prdFlavor, 'appIdIos');
    final devSuffix = _requiredString(devFlavor, 'appIdSuffix');

    final changes = <_FileChange>[
      _jsonChange(devFlavorFile, <String, Object?>{
        ...devFlavor,
        'appIdAndroid': appId,
        'appIdIos': appId,
      }),
      _jsonChange(prdFlavorFile, <String, Object?>{
        ...prdFlavor,
        'appIdAndroid': appId,
        'appIdIos': appId,
      }),
      await _textReplacement('apps/app/pubspec.yaml', <String, String>{
        'package_name: $oldAndroidAppId$devSuffix':
            'package_name: $appId$devSuffix',
        'bundle_id: $oldIosBundleId$devSuffix': 'bundle_id: $appId$devSuffix',
      }),
      await _textReplacement(
        'apps/app/integration_test/app_flow_test.dart',
        <String, String>{
          "packageName: '$oldAndroidAppId$devSuffix'":
              "packageName: '$appId$devSuffix'",
        },
      ),
      await _replaceGoogleServices(
        'apps/app/android/app/src/dev/google-services.json',
        oldAndroidAppId: oldAndroidAppId,
        oldIosBundleId: oldIosBundleId,
        newAppId: appId,
      ),
      await _replaceGoogleServices(
        'apps/app/android/app/src/prd/google-services.json',
        oldAndroidAppId: oldAndroidAppId,
        oldIosBundleId: oldIosBundleId,
        newAppId: appId,
      ),
      await _textReplacement(
        'apps/app/ios/dev/GoogleService-Info.plist',
        <String, String>{
          '<string>$oldIosBundleId$devSuffix</string>':
              '<string>$appId$devSuffix</string>',
        },
      ),
      await _textReplacement(
        'apps/app/ios/prd/GoogleService-Info.plist',
        <String, String>{
          '<string>$oldIosBundleId</string>': '<string>$appId</string>',
        },
      ),
      await _textReplacement(
        'packages/infrastructure/firebase/lib/src/common/config/firebase_options.dart',
        <String, String>{
          "iosBundleId: '$oldIosBundleId'": "iosBundleId: '$appId'",
        },
      ),
      await _textReplacement(
        'packages/infrastructure/firebase/lib/src/common/config/firebase_options_dev.dart',
        <String, String>{
          "iosBundleId: '$oldIosBundleId$devSuffix'":
              "iosBundleId: '$appId$devSuffix'",
        },
      ),
    ];

    final androidChange = await _androidNamespaceChange(appId);
    await _validateMainActivityMove(androidChange);
    changes.add(androidChange.gradleChange);

    final changedPaths = <String>[];
    for (final change in changes) {
      if (!change.hasChanges) {
        continue;
      }
      changedPaths.add(change.relativePath);
      if (!dryRun) {
        await change.file.writeAsString(change.updatedContent);
      }
    }

    if (androidChange.sourcePath != androidChange.destinationPath) {
      changedPaths
        ..add(androidChange.sourcePath)
        ..add(androidChange.destinationPath);
      if (!dryRun) {
        await _moveMainActivity(androidChange);
      }
    }

    return AppIdReplacementResult(List.unmodifiable(changedPaths));
  }

  Future<_AndroidNamespaceChange> _androidNamespaceChange(String appId) async {
    const gradlePath = 'apps/app/android/app/build.gradle';
    final gradleFile = _file(gradlePath);
    final content = await gradleFile.readAsString();
    final match = RegExp(r'namespace\s*=\s*"([^"]+)"').firstMatch(content);
    if (match == null) {
      throw const FormatException('Android namespaceが見つかりません');
    }
    final oldNamespace = match.group(1)!;
    final gradleChange = _FileChange(
      gradleFile,
      gradlePath,
      content,
      content.replaceFirst(
        'namespace = "$oldNamespace"',
        'namespace = "$appId"',
      ),
    );
    final sourcePath =
        'apps/app/android/app/src/main/kotlin/${oldNamespace.replaceAll('.', '/')}/MainActivity.kt';
    final destinationPath =
        'apps/app/android/app/src/main/kotlin/${appId.replaceAll('.', '/')}/MainActivity.kt';
    return _AndroidNamespaceChange(
      gradleChange: gradleChange,
      oldNamespace: oldNamespace,
      sourcePath: sourcePath,
      destinationPath: destinationPath,
    );
  }

  Future<void> _moveMainActivity(_AndroidNamespaceChange change) async {
    final source = _file(change.sourcePath);
    final destination = _file(change.destinationPath);
    await destination.parent.create(recursive: true);
    final content = await source.readAsString();
    await destination.writeAsString(
      content.replaceFirst(
        'package ${change.oldNamespace}',
        'package ${change.destinationNamespace}',
      ),
    );
    await source.delete();
    await _deleteEmptyParents(
      source.parent,
      stopAt: _directory('apps/app/android/app/src/main/kotlin'),
    );
  }

  Future<void> _validateMainActivityMove(_AndroidNamespaceChange change) async {
    if (change.sourcePath == change.destinationPath) {
      return;
    }
    final source = _file(change.sourcePath);
    if (!await source.exists()) {
      throw FileSystemException('MainActivity.ktが見つかりません', source.path);
    }
    final destination = _file(change.destinationPath);
    if (await destination.exists()) {
      throw FileSystemException(
        '移動先にMainActivity.ktがすでに存在します',
        destination.path,
      );
    }
  }

  Future<void> _deleteEmptyParents(
    Directory directory, {
    required Directory stopAt,
  }) async {
    var current = directory;
    while (current.path != stopAt.path && await current.exists()) {
      if (await current.list().isEmpty) {
        final parent = current.parent;
        await current.delete();
        current = parent;
      } else {
        return;
      }
    }
  }

  Future<_FileChange> _replaceGoogleServices(
    String relativePath, {
    required String oldAndroidAppId,
    required String oldIosBundleId,
    required String newAppId,
  }) async {
    final file = _file(relativePath);
    final json = await _readJsonObject(file);
    final updated =
        _replaceJsonIds(
              json,
              oldAndroidAppId: oldAndroidAppId,
              oldIosBundleId: oldIosBundleId,
              newAppId: newAppId,
            )
            as Map<String, Object?>;
    return _jsonChange(file, updated, relativePath: relativePath);
  }

  Object? _replaceJsonIds(
    Object? value, {
    required String oldAndroidAppId,
    required String oldIosBundleId,
    required String newAppId,
    String? key,
  }) {
    if (value is Map<String, Object?>) {
      return value.map(
        (entryKey, entryValue) => MapEntry(
          entryKey,
          _replaceJsonIds(
            entryValue,
            oldAndroidAppId: oldAndroidAppId,
            oldIosBundleId: oldIosBundleId,
            newAppId: newAppId,
            key: entryKey,
          ),
        ),
      );
    }
    if (value is List<Object?>) {
      return value
          .map(
            (item) => _replaceJsonIds(
              item,
              oldAndroidAppId: oldAndroidAppId,
              oldIosBundleId: oldIosBundleId,
              newAppId: newAppId,
              key: key,
            ),
          )
          .toList();
    }
    if (value is String && key == 'package_name') {
      return _replaceIdPrefix(value, oldAndroidAppId, newAppId);
    }
    if (value is String && key == 'bundle_id') {
      return _replaceIdPrefix(value, oldIosBundleId, newAppId);
    }
    return value;
  }

  String _replaceIdPrefix(String value, String oldId, String newId) {
    if (value == oldId) {
      return newId;
    }
    if (value.startsWith('$oldId.')) {
      return '$newId${value.substring(oldId.length)}';
    }
    return value;
  }

  Future<_FileChange> _textReplacement(
    String relativePath,
    Map<String, String> replacements,
  ) async {
    final file = _file(relativePath);
    final original = await file.readAsString();
    var updated = original;
    for (final replacement in replacements.entries) {
      updated = updated.replaceAll(replacement.key, replacement.value);
    }
    return _FileChange(file, relativePath, original, updated);
  }

  _FileChange _jsonChange(
    File file,
    Map<String, Object?> value, {
    String? relativePath,
  }) {
    final path = relativePath ?? _relativePath(file);
    return _FileChange(
      file,
      path,
      file.readAsStringSync(),
      '${const JsonEncoder.withIndent('  ').convert(value)}\n',
    );
  }

  Future<Map<String, Object?>> _readJsonObject(File file) async {
    final value = jsonDecode(await file.readAsString());
    if (value is! Map<String, Object?>) {
      throw FormatException('JSONオブジェクトではありません: ${file.path}');
    }
    return value;
  }

  String _requiredString(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is! String) {
      throw FormatException('$keyが文字列ではありません');
    }
    return value;
  }

  void _validateAppId(String appId) {
    final pattern = RegExp(
      r'^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*){1,}$',
    );
    if (!pattern.hasMatch(appId)) {
      throw FormatException('アプリIDは逆DNS形式で指定してください: $appId');
    }
  }

  File _file(String relativePath) =>
      File('${rootDirectory.path}/$relativePath');

  Directory _directory(String relativePath) =>
      Directory('${rootDirectory.path}/$relativePath');

  String _relativePath(File file) =>
      file.path.substring(rootDirectory.path.length + 1);
}

final class _FileChange {
  const _FileChange(
    this.file,
    this.relativePath,
    this.originalContent,
    this.updatedContent,
  );

  final File file;
  final String relativePath;
  final String originalContent;
  final String updatedContent;

  bool get hasChanges => originalContent != updatedContent;
}

final class _AndroidNamespaceChange {
  const _AndroidNamespaceChange({
    required this.gradleChange,
    required this.oldNamespace,
    required this.sourcePath,
    required this.destinationPath,
  });

  final _FileChange gradleChange;
  final String oldNamespace;
  final String sourcePath;
  final String destinationPath;

  String get destinationNamespace {
    final segments = destinationPath.split('/');
    final kotlinIndex = segments.indexOf('kotlin');
    return segments.sublist(kotlinIndex + 1, segments.length - 1).join('.');
  }
}
