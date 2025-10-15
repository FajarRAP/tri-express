import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/states.dart';

mixin PreviewGoodMixin<S> on Cubit<S> {
  void searchGoods(String keyword) {
    final currentState = state;
    if (currentState is! GoodSearchableState) return;

    final allGoods = currentState.allGoods;
    if (keyword.isEmpty) {
      final newState = currentState.copyWithFiltered(filteredGoods: allGoods);
      return emit(newState as S);
    }

    final lowerKeyword = keyword.toLowerCase();
    final results = allGoods.where((good) {
      final goodNameMatch = good.name.toLowerCase().contains(lowerKeyword);
      final customerNameMatch =
          good.customer.name.toLowerCase().contains(lowerKeyword);
      final invoiceNumberMatch =
          good.invoiceNumber.toLowerCase().contains(lowerKeyword);
      final trackingNumberMatch =
          good.receiptNumber.toLowerCase().contains(lowerKeyword);

      return goodNameMatch ||
          customerNameMatch ||
          invoiceNumberMatch ||
          trackingNumberMatch;
    }).toList();

    final newState = currentState.copyWithFiltered(filteredGoods: results);
    emit(newState as S);
  }

  void clearGoods() {
    final currentState = state;
    if (currentState is! GoodSearchableState) return;

    final newState = currentState.copyWithFiltered(
      allGoods: [],
      filteredGoods: [],
    );
    emit(newState as S);
  }
}
