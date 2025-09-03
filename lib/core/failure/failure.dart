import 'package:flutter/foundation.dart';

class Failure {
  const Failure({
    required String? message,
    this.statusCode = 500,
  }) : message = (kDebugMode ? message : null) ?? 'Terjadi Kesalahan';
  final String message;
  final int statusCode;
}
