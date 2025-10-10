import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../exceptions/server_exception.dart';
import '../widgets/badges/secondary_badge.dart';
import '../widgets/badges/success_badge.dart';
import '../widgets/badges/warning_badge.dart';

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

Widget determineBadge(int status, String label) {
  switch (status) {
    case 0:
    case 1:
    case 3:
    case 5:
    case 7:
      return SuccessBadge(label: label);
    case 4:
    case 6:
    case 8:
      return WarningBadge(label: label);
    default:
      return SecondaryBadge(label: label);
  }
}

extension DateTimeExtension on DateTime {
  String get toDDMMMMYYYY => DateFormat('dd MMMM yyyy').format(this);
  String get toDDMMMM => DateFormat('dd MMMM').format(this);
  String get toHHmm => DateFormat('HH:mm').format(this);
  String get toYYYYMMDD => DateFormat('yyyy-MM-dd').format(this);
  String get toDDMMMYYY => DateFormat('dd MMM yyyy').format(this);
  String get dayDiffenrences =>
      this.difference(DateTime.now()).abs().inDays.toString();
}
