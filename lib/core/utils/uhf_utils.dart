import 'package:flutter/services.dart';

import '../../features/core/data/models/uhf_result_model.dart';
import '../../features/core/domain/entities/uhf_result_entity.dart';
import 'constants.dart';

class UHFResponse {
  const UHFResponse({
    required this.message,
    required this.statusCode,
  });

  factory UHFResponse.fromJson(Map<String, dynamic> json) =>
      UHFResponse(message: json['message'], statusCode: json['status_code']);

  final String message;
  final int statusCode;
}

class UHFMethodHandler {
  const UHFMethodHandler(this._platform);

  final MethodChannel _platform;

  Future<dynamic> methodHandler(
    MethodCall call, {
    required void Function(UHFResultEntity result) onGetTag,
    required void Function(String toggleCase, UHFResponse response)
        onToggleInventory,
  }) async {
    final map = Map<String, dynamic>.from(call.arguments);

    switch (call.method) {
      case getTagInfoMethod:
        final tagInfo = UHFResultModel.fromJson(map).toEntity();
        onGetTag(tagInfo);
        break;
      case startInventoryMethod:
      case stopInventoryMethod:
      case failedInventoryMethod:
        final response = UHFResponse.fromJson(map);
        onToggleInventory(call.method, response);
        break;
    }
  }

  Future<int> invokeHandleInventory() async {
    return await _platform.invokeMethod<int>(handleInventoryButtonMethod) ?? -1;
  }
}
