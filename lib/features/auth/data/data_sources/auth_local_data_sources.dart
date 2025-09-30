import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/exceptions/cache_exception.dart';
import '../../../../core/utils/constants.dart';

abstract interface class AuthLocalDataSources {
  Future<void> cacheToken(String accessToken, String? refreshToken);
  Future<void> clearToken();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
}

class AuthLocalDataSourcesImpl implements AuthLocalDataSources {
  const AuthLocalDataSourcesImpl({required this.storage});

  final FlutterSecureStorage storage;

  @override
  Future<void> cacheToken(String accessToken, String? refreshToken) async {
    try {
      await storage.write(key: accessTokenKey, value: accessToken);
      await storage.write(key: refreshTokenKey, value: refreshToken);
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await storage.delete(key: accessTokenKey);
      await storage.delete(key: refreshTokenKey);
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await storage.read(key: accessTokenKey);
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await storage.read(key: refreshTokenKey);
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }
}
