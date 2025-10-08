import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/exceptions/cache_exception.dart';
import '../../../../core/utils/constants.dart';

abstract interface class CoreLocalDataSource {
  Future<void> completeOnboarding();
  Future<String?> getOnboardingStatus();
}

class CoreLocalDataSourceImpl implements CoreLocalDataSource {
  const CoreLocalDataSourceImpl({required this.storage});

  final FlutterSecureStorage storage;

  @override
  Future<void> completeOnboarding() async {
    try {
      await storage.write(key: onboardingKey, value: 'true');
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }

  @override
  Future<String?> getOnboardingStatus() async {
    try {
      return await storage.read(key: onboardingKey);
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }
}
