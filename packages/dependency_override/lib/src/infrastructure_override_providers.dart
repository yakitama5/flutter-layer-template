import 'package:packages_application/core.dart';
import 'package:packages_application/designsystem.dart';
import 'package:packages_application/goods.dart';
import 'package:packages_application/user.dart';
import 'package:infrastructure_firebase/core.dart';
import 'package:infrastructure_firebase/user.dart';
import 'package:infrastructure_mock/goods.dart';
import 'package:infrastructure_shared_preferences/designsystem.dart';
import 'package:infrastructure_shared_preferences/goods.dart';
import 'package:infrastructure_shared_preferences/init.dart';
import 'package:riverpod/misc.dart';

Future<List<Override>> initializeInfrastructureProviders() async {
  return <Override>[
    // SharedPreferences
    ...await initializeSharedPreferencesProviders(),
    themeRepositoryProvider.overrideWith(SharedPreferencesThemeRepository.new),
    goodsConfigRepositoryProvider.overrideWith(
      SharedPreferencesGoodsConfigRepository.new,
    ),

    // Firebase
    userRepositoryProvider.overrideWith(FirebaseUserRepository.new),
    appMaintenanceRepositoryProvider.overrideWith(
      RemoteConfigAppMaintenanceRepository.new,
    ),
    appVersionRepositoryProvider.overrideWith(
      RemoteConfigAppVersionRepository.new,
    ),

    // Mock
    goodsRepositoryProvider.overrideWith(MockGoodsRepository.new),
  ];
}
