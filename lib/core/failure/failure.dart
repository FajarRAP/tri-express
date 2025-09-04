import 'package:flutter/foundation.dart';

class Failure {
  const Failure({
    String? message,
    int? statusCode,
  })  : message = (kDebugMode ? message : null) ?? 'Terjadi Kesalahan',
        statusCode = statusCode ?? 500;

  final String message;
  final int statusCode;
}

class ServerFailure extends Failure {
  const ServerFailure({
    String? message,
    super.statusCode,
  }) : super(
            message:
                (kDebugMode ? message : null) ?? 'Terjadi Kesalahan Server');
}

class CacheFailure extends Failure {
  const CacheFailure({
    String? message,
    super.statusCode,
  }) : super(
            message:
                (kDebugMode ? message : null) ?? 'Terjadi Kesalahan Cache');
}
