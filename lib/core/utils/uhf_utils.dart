import 'package:flutter/services.dart';

import '../../features/core/data/models/uhf_result_model.dart';
import '../../features/core/domain/entities/uhf_result_entity.dart';
import '../../features/inventory/presentation/cubit/scanner_cubit.dart';
import 'constants.dart';
import 'top_snackbar.dart';

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

mixin UHFMethodHandlerMixin {
  ScannerCubit get scannerCubit;
  void Function() get onInventoryStop;

  late final UHFMethodHandler _uhfMethodHandler;

  void initUHFMethodHandler(MethodChannel platform) {
    _uhfMethodHandler = UHFMethodHandler(platform);
    platform.setMethodCallHandler(
      (call) async => await _uhfMethodHandler.methodHandler(
        call,
        onGetTag: _handleGetTag,
        onToggleInventory: _handleInventory,
      ),
    );
  }

  void onReset() => scannerCubit.resetScanner();

  void onScan() async {
    final result = await _uhfMethodHandler.invokeHandleInventory();
    scannerCubit.updateInventoryStatus(result == 1);
  }

  void onQRScan(String barcodeDisplayValue) =>
      scannerCubit.addFromQRScanner(barcodeDisplayValue);

  void _handleGetTag(UHFResultEntity tagInfo) =>
      scannerCubit.addFromUHFReader(tagInfo);

  void _handleInventory(String toggleCase, UHFResponse response) {
    final isRunning = response.statusCode == 1;
    scannerCubit.updateInventoryStatus(isRunning);

    if (!isRunning) {
      onInventoryStop();
    }

    toggleCase == startInventoryMethod
        ? TopSnackbar.successSnackbar(message: response.message)
        : TopSnackbar.dangerSnackbar(message: response.message);
  }
}
