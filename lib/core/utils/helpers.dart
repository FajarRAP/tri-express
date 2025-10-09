import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
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

bool paginateWhenScrollEnd(ScrollNotification scrollState,
    {required void Function() paginate}) {
  if (scrollState is ScrollEndNotification) {
    paginate();
  }

  return false;
}

extension DateTimeExtension on DateTime {
  String get toDDMMMMYYYY => DateFormat('dd MMMM yyyy').format(this);
  String get toDDMMMM => DateFormat('dd MMMM').format(this);
  String get toHHmm => DateFormat('HH:mm').format(this);
  String get toYYYYMMDD => DateFormat('yyyy-MM-dd').format(this);
  String get toDDMMMYYY => DateFormat('dd MMM yyyy').format(this);
}
