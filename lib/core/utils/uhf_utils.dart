import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../features/core/data/models/uhf_result_model.dart';
import '../../features/core/domain/entities/uhf_result_entity.dart';
import '../../features/inventory/presentation/cubit/inventory_cubit.dart';
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

mixin UHFMethodHandlerMixin<T extends StatefulWidget> on State<T> {
  InventoryCubit get inventoryCubit;
  void Function() get onInventoryStop;

  late final UHFMethodHandler _uhfMethodHandler;
  final _uhfResults = <UHFResultEntity>[];
  var _isInventoryRunning = false;

  List<UHFResultEntity> get uhfResults => _uhfResults;
  bool get isInventoryRunning => _isInventoryRunning;

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

  void onReset() {
    setState(() {
      _uhfResults.clear();
      inventoryCubit.resetUHFScan();
    });
  }

  void onScan() async {
    final result = await _uhfMethodHandler.invokeHandleInventory();
    setState(() => _isInventoryRunning = result == 1);
  }

  void onQRScan(String barcodeDisplayValue) {
    final index = _uhfResults.indexWhere((e) => e.epcId == barcodeDisplayValue);
    final result = UHFResultEntity(
      epcId: barcodeDisplayValue,
      tidId: '-',
      frequency: 0,
      rssi: 0,
      count: 1,
    );

    setState(() => index != -1
        ? _uhfResults[index] = _uhfResults[index].updateInfo(tagInfo: result)
        : _uhfResults.add(result));
    inventoryCubit.qrCodeScan();
  }

  void _handleGetTag(UHFResultEntity tagInfo) {
    final index = _uhfResults.indexWhere((e) => e.epcId == tagInfo.epcId);

    setState(() => index != -1
        ? _uhfResults[index] = _uhfResults[index].updateInfo(tagInfo: tagInfo)
        : _uhfResults.add(tagInfo));
  }

  void _handleInventory(String toggleCase, UHFResponse response) {
    setState(() => _isInventoryRunning = response.statusCode == 1);

    !_isInventoryRunning ? onInventoryStop() : inventoryCubit.onUHFScan();

    toggleCase == startInventoryMethod
        ? TopSnackbar.successSnackbar(message: response.message)
        : TopSnackbar.dangerSnackbar(message: response.message);
  }
}

mixin UHFMethodHandlerMixinV2 {
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
