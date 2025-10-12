import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/states.dart';

mixin PreviewBatchMixin<T> on Cubit<T> {
  void searchBatches(String keyword) {
    final currentState = state;
    if (currentState is! BatchSearchableState) return;

    final allBatches = currentState.allBatches;
    if (keyword.isEmpty) {
      final newState =
          currentState.copyWithFiltered(filteredBatches: allBatches);
      return emit(newState as T);
    }

    final lowerKeyword = keyword.toLowerCase();
    final results = allBatches.where(
      (batch) {
        final batchNameMatch = batch.name.toLowerCase().contains(lowerKeyword);
        final trackingNumberMatch =
            batch.trackingNumber.toLowerCase().contains(lowerKeyword);

        return batchNameMatch || trackingNumberMatch;
      },
    ).toList();

    final newState = currentState.copyWithFiltered(filteredBatches: results);
    emit(newState as T);
  }

  void clearBatches() {
    final currentState = state;
    if (currentState is! BatchSearchableState) return;

    final newState = currentState.copyWithFiltered(
      allBatches: [],
      filteredBatches: [],
    );
    emit(newState as T);
  }
}
