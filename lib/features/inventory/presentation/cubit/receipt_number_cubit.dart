import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';

part 'receipt_number_state.dart';

class ReceiptNumberCubit extends Cubit<ReceiptNumberState> {
  ReceiptNumberCubit({required BatchEntity batch})
      : super(ReceiptNumberState(batch: batch, goods: batch.goods));

  void searchReceiptNumbers([String keyword = '']) {
    final filteredReceiptNumbers = <GoodEntity>[];

    if (keyword.isEmpty) {
      filteredReceiptNumbers.addAll(state._batch.goods);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      final results = state._batch.goods
          .where((e) => e.receiptNumber.toLowerCase().contains(lowerKeyword))
          .toList();
      filteredReceiptNumbers.addAll(results);
    }

    emit(state.copyWith(goods: filteredReceiptNumbers));
  }
}
