import 'package:flutter/foundation.dart';

class CacheException implements Exception {
  const CacheException({
    String? message,
    this.statusCode = 500,
  }) : message = (kDebugMode ? message : null) ?? 'Terjadi Kesalahan Cache';

  final String message;
  final int statusCode;
}
