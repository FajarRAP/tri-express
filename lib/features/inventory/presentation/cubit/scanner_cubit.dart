import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/uhf_result_entity.dart';

part 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(const ScannerState(uhfResults: []));

  void addFromUHFReader(UHFResultEntity tagInfo) {
    final index = state.uhfResults.indexWhere((e) => e.epcId == tagInfo.epcId);
    if (index != -1) {
      final updatedTag = state.uhfResults[index].copyWith(
        frequency: tagInfo.frequency,
        rssi: tagInfo.rssi,
        count: state.uhfResults[index].count + 1,
      );
      final updatedList = List<UHFResultEntity>.from(state.uhfResults);
      updatedList[index] = updatedTag;
      emit(state.copyWith(
        uhfResults: updatedList,
        isFromUHFReader: true,
        isFromQRScanner: false,
      ));
    } else {
      emit(state.copyWith(
        uhfResults: [...state.uhfResults, tagInfo],
        isFromUHFReader: true,
        isFromQRScanner: false,
      ));
    }
  }

  void addFromQRScanner(String barcodeDisplayValue) {
    final index =
        state.uhfResults.indexWhere((e) => e.epcId == barcodeDisplayValue);
    final result = UHFResultEntity(
      epcId: barcodeDisplayValue,
      tidId: '-',
      frequency: 0,
      rssi: 0,
      count: 1,
    );
    if (index != -1) return;

    emit(state.copyWith(
      uhfResults: [...state.uhfResults, result],
      isFromUHFReader: false,
      isFromQRScanner: true,
    ));
  }

  void resetScanner() => emit(ScannerState.initial());

  void updateInventoryStatus(bool isRunning) => emit(
      state.copyWith(isFromUHFReader: isRunning, isFromQRScanner: isRunning));
}
