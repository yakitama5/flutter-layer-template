import 'package:riverpod/riverpod.dart';
import 'package:version/version.dart';

import '../interface/app_version_repository.dart';

final appLatestVersionProvider = StreamProvider.autoDispose<Version>(
  (ref) => ref.watch(appVersionRepositoryProvider).listenLatestAppVersion(),
);
