import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/use_case/use_case.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/use_cases/create_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_inventories_count_use_case.dart';
import '../../domain/use_cases/fetch_inventories_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../../domain/use_cases/fetch_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit({
    required CreateReceiveShipmentsUseCase createReceiveShipmentsUseCase,
    required FetchDeliveryShipmentsUseCase fetchDeliveryShipmentsUseCase,
    required FetchInventoriesUseCase fetchInventoriesUseCase,
    required FetchInventoriesCountUseCase fetchInventoriesCountUseCase,
    required FetchOnTheWayShipmentsUseCase fetchOnTheWayShipmentsUseCase,
    required FetchPreviewReceiveShipmentsUseCase
        fetchPreviewReceiveShipmentsUseCase,
    required FetchPreviewPrepareShipmentsUseCase
        fetchPreviewPrepareShipmentsUseCase,
    required FetchPrepareShipmentsUseCase fetchPrepareShipmentsUseCase,
    required FetchReceiveShipmentsUseCase fetchReceiveShipmentsUseCase,
  })  : _createReceiveShipmentsUseCase = createReceiveShipmentsUseCase,
        _fetchDeliveryShipmentsUseCase = fetchDeliveryShipmentsUseCase,
        _fetchInventoriesUseCase = fetchInventoriesUseCase,
        _fetchInventoriesCountUseCase = fetchInventoriesCountUseCase,
        _fetchOnTheWayShipmentsUseCase = fetchOnTheWayShipmentsUseCase,
        _fetchPreviewReceiveShipmentsUseCase =
            fetchPreviewReceiveShipmentsUseCase,
        _fetchPreviewPrepareShipmentsUseCase =
            fetchPreviewPrepareShipmentsUseCase,
        _fetchPrepareShipmentsUseCase = fetchPrepareShipmentsUseCase,
        _fetchReceiveShipmentsUseCase = fetchReceiveShipmentsUseCase,
        super(InventoryInitial());

  final CreateReceiveShipmentsUseCase _createReceiveShipmentsUseCase;
  final FetchDeliveryShipmentsUseCase _fetchDeliveryShipmentsUseCase;
  final FetchInventoriesUseCase _fetchInventoriesUseCase;
  final FetchInventoriesCountUseCase _fetchInventoriesCountUseCase;
  final FetchOnTheWayShipmentsUseCase _fetchOnTheWayShipmentsUseCase;
  final FetchPreviewReceiveShipmentsUseCase
      _fetchPreviewReceiveShipmentsUseCase;
  final FetchPreviewPrepareShipmentsUseCase
      _fetchPreviewPrepareShipmentsUseCase;
  final FetchPrepareShipmentsUseCase _fetchPrepareShipmentsUseCase;
  final FetchReceiveShipmentsUseCase _fetchReceiveShipmentsUseCase;

  var _currentPage = 1;
  final _deliveryBatches = <BatchEntity>[];
  final _inventories = <BatchEntity>[];
  final _onTheWayBatches = <BatchEntity>[];
  final _prepareBatches = <BatchEntity>[];
  final _receiveBatches = <BatchEntity>[];

  final _previewBatches = <BatchEntity>[];
  final previewGoods = <GoodEntity>[];

  Future<void> createReceiveShipments(
      {required DateTime receivedAt, required List<String> uniqueCodes}) async {
    emit(CreateShipmentsLoading());

    final params = CreateReceiveShipmentsUseCaseParams(
      receivedAt: receivedAt,
      uniqueCodes: uniqueCodes,
    );
    final result = await _createReceiveShipmentsUseCase(params);

    result.fold(
      (failure) => emit(CreateShipmentsError(message: failure.message)),
      (message) => emit(CreateShipmentsLoaded(message: message)),
    );
  }

  Future<void> fetchDeliveryShipments({String? search}) async {
    emit(FetchDeliveryShipmentsLoading());

    final params = FetchDeliveryShipmentsUseCaseParams(
      page: _currentPage = 1,
      search: search,
    );
    final result = await _fetchDeliveryShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchDeliveryShipmentsError(message: failure.message)),
      (batches) => emit(FetchDeliveryShipmentsLoaded(
          batches: _deliveryBatches
            ..clear()
            ..addAll(batches))),
    );
  }

  Future<void> fetchDeliveryShipmentsPaginate({String? search}) async {
    emit(ListPaginateLoading());

    final params = FetchDeliveryShipmentsUseCaseParams(
      page: ++_currentPage,
      search: search,
    );
    final result = await _fetchDeliveryShipmentsUseCase(params);

    result.fold(
        (failure) => emit(ListPaginateError(message: failure.message)),
        (batches) => batches.isEmpty
            ? emit(ListPaginateLast(currentPage: _currentPage = 1))
            : emit(FetchDeliveryShipmentsLoaded(
                batches: _deliveryBatches..addAll(batches))));
  }

  Future<void> fetchInventories({String? search}) async {
    emit(FetchInventoriesLoading());

    final params = FetchInventoriesUseCaseParams(
      page: _currentPage = 1,
      search: search,
    );
    final result = await _fetchInventoriesUseCase(params);

    result.fold(
      (failure) => emit(FetchInventoriesError(message: failure.message)),
      (batches) => emit(FetchInventoriesLoaded(
          batches: _inventories
            ..clear()
            ..addAll(batches))),
    );
  }

  Future<void> fetchInventoriesCount() async {
    emit(FetchInventoriesCountLoading());

    final result = await _fetchInventoriesCountUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchInventoriesCountError(message: failure.message)),
      (count) => emit(FetchInventoriesCountLoaded(count: count)),
    );
  }

  Future<void> fetchInventoriesPaginate({String? search}) async {
    emit(ListPaginateLoading());

    final params = FetchInventoriesUseCaseParams(
      page: ++_currentPage,
      search: search,
    );
    final result = await _fetchInventoriesUseCase(params);

    result.fold(
      (failure) => emit(ListPaginateError(message: failure.message)),
      (batches) => batches.isEmpty
          ? emit(ListPaginateLast(currentPage: _currentPage = 1))
          : emit(
              FetchInventoriesLoaded(batches: _inventories..addAll(batches))),
    );
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

  Future<void> fetchPickUpShipments({String? search}) async {}

  Future<void> fetchPrepareShipments({String? search}) async {
    emit(FetchPrepareShipmentsLoading());

    final params = FetchPrepareShipmentsUseCaseParams(
      page: _currentPage = 1,
      search: search,
    );
    final result = await _fetchPrepareShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchPrepareShipmentsError(message: failure.message)),
      (batches) => emit(FetchPrepareShipmentsLoaded(
          batches: _prepareBatches
            ..clear()
            ..addAll(batches))),
    );
  }

  Future<void> fetchPrepareShipmentsPaginate({String? search}) async {
    emit(ListPaginateLoading());

    final params = FetchPrepareShipmentsUseCaseParams(
      page: ++_currentPage,
      search: search,
    );
    final result = await _fetchPrepareShipmentsUseCase(params);

    result.fold(
      (failure) => emit(ListPaginateError(message: failure.message)),
      (batches) => batches.isEmpty
          ? emit(ListPaginateLast(currentPage: _currentPage = 1))
          : emit(FetchPrepareShipmentsLoaded(
              batches: _prepareBatches..addAll(batches))),
    );
  }

  Future<void> fetchPreviewPrepareShipments(
      {required List<String> uniqueCodes}) async {
    emit(FetchPreviewPrepareShipmentsLoading());

    // final result = await _fetchPreviewPrepareShipmentsUseCase(uniqueCodes);
    final result = await _fetchPreviewPrepareShipmentsUseCase([
      'A00000001758',
      'A00000001759',
      'A00000001760',
      'A00000001761',
      'A00000001762',
      'A00000000167',
      'A00000000168',
    ]);

    result.fold(
      (failure) =>
          emit(FetchPreviewPrepareShipmentsError(message: failure.message)),
      (goods) => emit(FetchPreviewPrepareShipmentsLoaded(
          goods: previewGoods
            ..clear()
            ..addAll(goods))),
    );
  }

  Future<void> fetchPreviewReceiveShipments(
      {required List<String> uniqueCodes}) async {
    emit(FetchPreviewReceiveShipmentsLoading());

    final params = FetchPreviewReceiveShipmentsUseCaseParams(
      uniqueCodes: uniqueCodes,
    );
    final result = await _fetchPreviewReceiveShipmentsUseCase(params);

    result.fold(
      (failure) =>
          emit(FetchPreviewReceiveShipmentsError(message: failure.message)),
      (batches) => emit(FetchPreviewReceiveShipmentsLoaded(
          batches: _previewBatches
            ..clear()
            ..addAll(batches))),
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

  void onUHFScan() => emit(OnUHFScan());
  void qrCodeScan() => emit(QRCodeScan());
  void resetUHFScan() => emit(ResetUHFScan());
}
