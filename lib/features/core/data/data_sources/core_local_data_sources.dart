import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/exceptions/cache_exception.dart';
import '../../../../core/utils/constants.dart';

abstract class CoreLocalDataSources {
  Future<void> completeOnboarding();
}

class CoreLocalDataSourcesImpl implements CoreLocalDataSources {
  const CoreLocalDataSourcesImpl({required this.storage});

  final FlutterSecureStorage storage;

  @override
  Future<void> completeOnboarding() async {
    try {
      await storage.write(key: onboardingKey, value: 'true');
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }
}
