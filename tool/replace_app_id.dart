import 'dart:io';

import 'src/app_id_replacer.dart';

Future<void> main(List<String> arguments) async {
  try {
    final options = _Options.parse(arguments);
    final result = await AppIdReplacer(
      rootDirectory: Directory(options.rootPath),
    ).replace(appId: options.appId, dryRun: options.dryRun);

    if (result.changedPaths.isEmpty) {
      stdout.writeln('変更はありません。');
      return;
    }

    stdout.writeln(options.dryRun ? '変更予定:' : '変更しました:');
    for (final path in result.changedPaths) {
      stdout.writeln('- $path');
    }
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    stderr.writeln(_Options.usage);
    exitCode = 64;
  } on FileSystemException catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  }
}

final class _Options {
  const _Options({
    required this.appId,
    required this.rootPath,
    required this.dryRun,
  });

  final String appId;
  final String rootPath;
  final bool dryRun;

  static const usage =
      '使い方: dart run tool/replace_app_id.dart '
      '--app-id <com.example.app> [--root <path>] [--dry-run]';

  static _Options parse(List<String> arguments) {
    String? appId;
    var rootPath = Directory.current.path;
    var dryRun = false;

    for (var index = 0; index < arguments.length; index++) {
      switch (arguments[index]) {
        case '--app-id':
          appId = _nextValue(arguments, ++index, '--app-id');
        case '--root':
          rootPath = _nextValue(arguments, ++index, '--root');
        case '--dry-run':
          dryRun = true;
        case '--help' || '-h':
          stdout.writeln(usage);
          exit(0);
        default:
          throw FormatException('不明なオプションです: ${arguments[index]}');
      }
    }

    if (appId == null) {
      throw const FormatException('--app-idは必須です');
    }
    return _Options(appId: appId, rootPath: rootPath, dryRun: dryRun);
  }

  static String _nextValue(List<String> arguments, int index, String option) {
    if (index >= arguments.length || arguments[index].startsWith('--')) {
      throw FormatException('$optionの値がありません');
    }
    return arguments[index];
  }
}
