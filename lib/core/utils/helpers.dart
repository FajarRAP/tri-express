import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../exceptions/server_exception.dart';

ServerException handleDioException(DioException de) {
  final data = de.response?.data;
  final isMap = data is Map<String, dynamic>;

  switch (de.response?.statusCode) {
    default:
      return ServerException(
        message: isMap ? data['message'] : null,
        statusCode: de.response?.statusCode ?? 500,
      );
  }
}

extension DateTimeExtension on DateTime {
  String get toDDMMMMYYYY => DateFormat('dd MMMM yyyy').format(this);
}
