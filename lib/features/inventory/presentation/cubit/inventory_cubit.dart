import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/batch_entity.dart';
import '../../domain/use_cases/fetch_delivery_goods_use_case.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit({
    required FetchDeliveryGoodsUseCase fetchDeliveryGoodsUseCase,
  })  : _fetchDeliveryGoodsUseCase = fetchDeliveryGoodsUseCase,
        super(InventoryInitial());

  final FetchDeliveryGoodsUseCase _fetchDeliveryGoodsUseCase;

  var _currentPage = 1;
  final _deliveryBatches = <BatchEntity>[];

  Future<void> fetchDeliveryGoods() async {
    emit(FetchDeliveryGoodsLoading());

    final params =
        FetchDeliveryGoodsUseCaseParams(currentPage: _currentPage = 1);
    final result = await _fetchDeliveryGoodsUseCase(params);

    result.fold(
      (failure) => emit(FetchDeliveryGoodsError(message: failure.message)),
      (batches) => emit(FetchDeliveryGoodsLoaded(
          batches: _deliveryBatches
            ..clear()
            ..addAll(batches))),
    );
  }

  Future<void> fetchDeliveryGoodsPaginate() async {
    emit(ListPaginateLoading());

    final params = FetchDeliveryGoodsUseCaseParams(currentPage: ++_currentPage);
    final result = await _fetchDeliveryGoodsUseCase(params);

    result.fold(
        (failure) => emit(ListPaginateError(message: failure.message)),
        (batches) => batches.isEmpty
            ? emit(ListPaginateLast(currentPage: _currentPage = 1))
            : emit(FetchDeliveryGoodsLoaded(
                batches: _deliveryBatches..addAll(batches))));
  }

  Future<void> fetchShipmentReceiptNumbers() async {
    emit(FetchShipmentReceiptNumbersLoading());

    await Future.delayed(const Duration(seconds: 1));

    emit(FetchShipmentReceiptNumbersLoaded(receiptNumbers: []));

    // final result = await _fetchReceiptNumbersUseCase();

    // result.fold(
    //   (failure) => emit(FetchReceiptNumbersError(message: failure.message)),
    //   (receiptNumbers) =>
    //       emit(FetchReceiptNumbersLoaded(receiptNumbers: receiptNumbers)),
    // );
  }
}
