import 'package:cloud_functions/cloud_functions.dart';
import 'package:infrastructure_firebase/src/common/config/region.dart';
import 'package:riverpod/riverpod.dart';

/// Firebase Functions
/// テスト時にDIすることを考慮して、Providerとして定義
final firebaseFunctionsProvider = Provider.autoDispose<FirebaseFunctions>(
  (ref) => FirebaseFunctions.instanceFor(region: firebaseRegion),
);
