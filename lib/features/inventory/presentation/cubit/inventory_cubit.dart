import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/batch_entity.dart';
import '../../domain/use_cases/fetch_delivery_goods_use_case.dart';
import '../../domain/use_cases/fetch_receive_goods_use_case.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit({
    required FetchDeliveryGoodsUseCase fetchDeliveryGoodsUseCase,
    required FetchReceiveGoodsUseCase fetchReceiveGoodsUseCase,
  })  : _fetchDeliveryGoodsUseCase = fetchDeliveryGoodsUseCase,
        _fetchReceiveGoodsUseCase = fetchReceiveGoodsUseCase,
        super(InventoryInitial());

  final FetchDeliveryGoodsUseCase _fetchDeliveryGoodsUseCase;
  final FetchReceiveGoodsUseCase _fetchReceiveGoodsUseCase;

  var _currentPage = 1;
  final _deliveryBatches = <BatchEntity>[];
  final _receiveBatches = <BatchEntity>[];

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
  }

  Future<void> fetchPrepareGoods() async {
    emit(FetchPrepareGoodsLoading());

    await Future.delayed(const Duration(seconds: 1));

    emit(FetchPrepareGoodsLoaded(batches: []));
  }

  Future<void> fetchReceiveGoods({String? search}) async {
    emit(FetchReceiveGoodsLoading());

    final params = FetchReceiveGoodsUseCaseParams(
      page: _currentPage = 1,
      search: search,
    );
    final result = await _fetchReceiveGoodsUseCase(params);

    result.fold(
      (failure) => emit(FetchReceiveGoodsError(message: failure.message)),
      (batches) => emit(FetchReceiveGoodsLoaded(
          batches: _receiveBatches
            ..clear()
            ..addAll(batches))),
    );
  }

  Future<void> fetchReceiveGoodsPaginate({String? search}) async {
    emit(ListPaginateLoading());

    final params = FetchReceiveGoodsUseCaseParams(
      page: ++_currentPage,
      search: search,
    );
    final result = await _fetchReceiveGoodsUseCase(params);

    result.fold(
      (failure) => emit(ListPaginateError(message: failure.message)),
      (batches) => batches.isEmpty
          ? emit(ListPaginateLast(currentPage: _currentPage = 1))
          : emit(FetchReceiveGoodsLoaded(
              batches: _receiveBatches..addAll(batches))),
    );
  }
}
