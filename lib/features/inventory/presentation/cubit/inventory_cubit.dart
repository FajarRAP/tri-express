import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/batch_entity.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit({
    required FetchDeliveryShipmentsUseCase fetchDeliveryShipmentsUseCase,
    required FetchOnTheWayShipmentsUseCase fetchOnTheWayShipmentsUseCase,
    required FetchReceiveShipmentsUseCase fetchReceiveShipmentsUseCase,
  })  : _fetchDeliveryShipmentsUseCase = fetchDeliveryShipmentsUseCase,
        _fetchOnTheWayShipmentsUseCase = fetchOnTheWayShipmentsUseCase,
        _fetchReceiveShipmentsUseCase = fetchReceiveShipmentsUseCase,
        super(InventoryInitial());

  final FetchDeliveryShipmentsUseCase _fetchDeliveryShipmentsUseCase;
  final FetchOnTheWayShipmentsUseCase _fetchOnTheWayShipmentsUseCase;
  final FetchReceiveShipmentsUseCase _fetchReceiveShipmentsUseCase;

  var _currentPage = 1;
  final _deliveryBatches = <BatchEntity>[];
  final _onTheWayBatches = <BatchEntity>[];
  final _receiveBatches = <BatchEntity>[];

  Future<void> fetchDeliveryShipments() async {
    emit(FetchDeliveryShipmentsLoading());

    final params = FetchDeliveryShipmentsUseCaseParams(page: _currentPage = 1);
    final result = await _fetchDeliveryShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchDeliveryShipmentsError(message: failure.message)),
      (batches) => emit(FetchDeliveryShipmentsLoaded(
          batches: _deliveryBatches
            ..clear()
            ..addAll(batches))),
    );
  }

  Future<void> fetchDeliveryShipmentsPaginate() async {
    emit(ListPaginateLoading());

    final params = FetchDeliveryShipmentsUseCaseParams(page: ++_currentPage);
    final result = await _fetchDeliveryShipmentsUseCase(params);

    result.fold(
        (failure) => emit(ListPaginateError(message: failure.message)),
        (batches) => batches.isEmpty
            ? emit(ListPaginateLast(currentPage: _currentPage = 1))
            : emit(FetchDeliveryShipmentsLoaded(
                batches: _deliveryBatches..addAll(batches))));
  }

  Future<void> fetchOnTheWayShipments({String? search}) async {
    emit(FetchOnTheWayShipmentsLoading());

    final params = FetchOnTheWayShipmentsUseCaseParams(
      page: _currentPage = 1,
      search: search,
    );
    final result = await _fetchOnTheWayShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchOnTheWayShipmentsError(message: failure.message)),
      (batches) => emit(FetchOnTheWayShipmentsLoaded(
          batches: _onTheWayBatches
            ..clear()
            ..addAll(batches))),
    );
  }

  Future<void> fetchOnTheWayShipmentsPaginate({String? search}) async {
    emit(ListPaginateLoading());

    final params = FetchOnTheWayShipmentsUseCaseParams(
      page: ++_currentPage,
      search: search,
    );
    final result = await _fetchOnTheWayShipmentsUseCase(params);

    result.fold(
      (failure) => emit(ListPaginateError(message: failure.message)),
      (batches) => batches.isEmpty
          ? emit(ListPaginateLast(currentPage: _currentPage = 1))
          : emit(FetchOnTheWayShipmentsLoaded(
              batches: _onTheWayBatches..addAll(batches))),
    );
  }

  Future<void> fetchReceiveShipments({String? search}) async {
    emit(FetchReceiveShipmentsLoading());

    final params = FetchReceiveShipmentsUseCaseParams(
      page: _currentPage = 1,
      search: search,
    );
    final result = await _fetchReceiveShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchReceiveShipmentsError(message: failure.message)),
      (batches) => emit(FetchReceiveShipmentsLoaded(
          batches: _receiveBatches
            ..clear()
            ..addAll(batches))),
    );
  }

  Future<void> fetchReceiveShipmentsPaginate({String? search}) async {
    emit(ListPaginateLoading());

    final params = FetchReceiveShipmentsUseCaseParams(
      page: ++_currentPage,
      search: search,
    );
    final result = await _fetchReceiveShipmentsUseCase(params);

    result.fold(
      (failure) => emit(ListPaginateError(message: failure.message)),
      (batches) => batches.isEmpty
          ? emit(ListPaginateLast(currentPage: _currentPage = 1))
          : emit(FetchReceiveShipmentsLoaded(
              batches: _receiveBatches..addAll(batches))),
    );
  }

  Future<void> fetchPrepareShipments() async {}
  Future<void> fetchPickUpShipments({String? search}) async {}
}
