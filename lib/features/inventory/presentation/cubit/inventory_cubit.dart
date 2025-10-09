import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/use_case/use_case.dart';
import '../../../core/domain/entities/dropdown_entity.dart';
import '../../../core/domain/entities/uhf_result_entity.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/entities/picked_good_entity.dart';
import '../../domain/entities/timeline_summary_entity.dart';
import '../../domain/use_cases/create_delivery_shipments_use_case.dart';
import '../../domain/use_cases/create_picked_up_goods_use_case.dart';
import '../../domain/use_cases/create_prepare_shipments_use_case.dart';
import '../../domain/use_cases/create_receive_shipments_use_case.dart';
import '../../domain/use_cases/delete_prepared_shipments_use_case.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_good_timeline_use_case.dart';
import '../../domain/use_cases/fetch_inventories_count_use_case.dart';
import '../../domain/use_cases/fetch_inventories_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../../domain/use_cases/fetch_picked_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_pick_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_preview_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit({
    required CreateDeliveryShipmentsUseCase createDeliveryShipmentsUseCase,
    required CreatePickedUpGoodsUseCase createPickedUpGoodsUseCase,
    required CreatePrepareShipmentsUseCase createPrepareShipmentsUseCase,
    required CreateReceiveShipmentsUseCase createReceiveShipmentsUseCase,
    required DeletePreparedShipmentsUseCase deletePreparedShipmentsUseCase,
    required FetchDeliveryShipmentsUseCase fetchDeliveryShipmentsUseCase,
    required FetchGoodTimelineUseCase fetchGoodTimelineUseCase,
    required FetchInventoriesUseCase fetchInventoriesUseCase,
    required FetchInventoriesCountUseCase fetchInventoriesCountUseCase,
    required FetchOnTheWayShipmentsUseCase fetchOnTheWayShipmentsUseCase,
    required FetchPreviewDeliveryShipmentsUseCase
        fetchPreviewDeliveryShipmentsUseCase,
    required FetchPreviewReceiveShipmentsUseCase
        fetchPreviewReceiveShipmentsUseCase,
    required FetchPreviewPrepareShipmentsUseCase
        fetchPreviewPrepareShipmentsUseCase,
    required FetchPrepareShipmentsUseCase fetchPrepareShipmentsUseCase,
    required FetchReceiveShipmentsUseCase fetchReceiveShipmentsUseCase,
    required FetchPickedUpGoodsUseCase fetchPickedUpGoodsUseCase,
    required FetchPreviewPickUpGoodsUseCase fetchPreviewPickUpGoodsUseCase,
  })  : _createDeliveryShipmentsUseCase = createDeliveryShipmentsUseCase,
        _createPickedUpGoodsUseCase = createPickedUpGoodsUseCase,
        _createPrepareShipmentsUseCase = createPrepareShipmentsUseCase,
        _createReceiveShipmentsUseCase = createReceiveShipmentsUseCase,
        _deletePreparedShipmentsUseCase = deletePreparedShipmentsUseCase,
        _fetchDeliveryShipmentsUseCase = fetchDeliveryShipmentsUseCase,
        _fetchGoodTimelineUseCase = fetchGoodTimelineUseCase,
        _fetchInventoriesUseCase = fetchInventoriesUseCase,
        _fetchInventoriesCountUseCase = fetchInventoriesCountUseCase,
        _fetchOnTheWayShipmentsUseCase = fetchOnTheWayShipmentsUseCase,
        _fetchPreviewDeliveryShipmentsUseCase =
            fetchPreviewDeliveryShipmentsUseCase,
        _fetchPreviewReceiveShipmentsUseCase =
            fetchPreviewReceiveShipmentsUseCase,
        _fetchPreviewPrepareShipmentsUseCase =
            fetchPreviewPrepareShipmentsUseCase,
        _fetchPrepareShipmentsUseCase = fetchPrepareShipmentsUseCase,
        _fetchReceiveShipmentsUseCase = fetchReceiveShipmentsUseCase,
        _fetchPickedUpGoodsUseCase = fetchPickedUpGoodsUseCase,
        _fetchPreviewPickUpGoodsUseCase = fetchPreviewPickUpGoodsUseCase,
        super(InventoryInitial());

  final CreateDeliveryShipmentsUseCase _createDeliveryShipmentsUseCase;
  final CreatePickedUpGoodsUseCase _createPickedUpGoodsUseCase;
  final CreatePrepareShipmentsUseCase _createPrepareShipmentsUseCase;
  final CreateReceiveShipmentsUseCase _createReceiveShipmentsUseCase;
  final DeletePreparedShipmentsUseCase _deletePreparedShipmentsUseCase;
  final FetchDeliveryShipmentsUseCase _fetchDeliveryShipmentsUseCase;
  final FetchGoodTimelineUseCase _fetchGoodTimelineUseCase;
  final FetchInventoriesUseCase _fetchInventoriesUseCase;
  final FetchInventoriesCountUseCase _fetchInventoriesCountUseCase;
  final FetchOnTheWayShipmentsUseCase _fetchOnTheWayShipmentsUseCase;
  final FetchPreviewDeliveryShipmentsUseCase
      _fetchPreviewDeliveryShipmentsUseCase;
  final FetchPreviewReceiveShipmentsUseCase
      _fetchPreviewReceiveShipmentsUseCase;
  final FetchPreviewPrepareShipmentsUseCase
      _fetchPreviewPrepareShipmentsUseCase;
  final FetchPreviewPickUpGoodsUseCase _fetchPreviewPickUpGoodsUseCase;
  final FetchPrepareShipmentsUseCase _fetchPrepareShipmentsUseCase;
  final FetchReceiveShipmentsUseCase _fetchReceiveShipmentsUseCase;
  final FetchPickedUpGoodsUseCase _fetchPickedUpGoodsUseCase;

  var _currentPage = 1;
  final _deliveryBatches = <BatchEntity>[];
  final _inventories = <BatchEntity>[];
  final _onTheWayBatches = <BatchEntity>[];
  final _prepareBatches = <BatchEntity>[];
  final _pickedGoods = <PickedGoodEntity>[];

  final previewGoods = <GoodEntity>[];

  Future<void> createDeliveryShipments({
    required DropdownEntity nextWarehouse,
    required DropdownEntity driver,
    required Set<BatchEntity> batches,
    required DateTime deliveredAt,
  }) async {
    emit(CreateShipmentsLoading());

    final uniqueCodes =
        batches.expand((e) => e.goods.expand((i) => i.uniqueCodes)).toList();
    final shipmentIds = batches.map((e) => e.id).toList();
    final params = CreateDeliveryShipmentsUseCaseParams(
      nextWarehouse: nextWarehouse,
      driver: driver,
      uniqueCodes: uniqueCodes,
      shipmentIds: shipmentIds,
      deliveredAt: deliveredAt,
    );
    final result = await _createDeliveryShipmentsUseCase(params);

    result.fold(
      (failure) => emit(CreateShipmentsError(message: failure.message)),
      (message) => emit(CreateShipmentsLoaded(message: message)),
    );
  }

  Future<void> createPickedUpGoods(
      {required Map<String, Set<String>> selectedCodes,
      required String note,
      required String pickedImagePath,
      required DateTime pickedUpAt}) async {
    emit(CreateShipmentsLoading());

    final receiptNumbers = selectedCodes.keys.toList();
    final uniqueCodes = selectedCodes.values.expand((codes) => codes).toList();
    final params = CreatePickedUpGoodsUseCaseParams(
      receiptNumbers: receiptNumbers,
      uniqueCodes: uniqueCodes,
      note: note,
      imagePath: pickedImagePath,
      pickedUpAt: pickedUpAt,
    );
    final result = await _createPickedUpGoodsUseCase(params);

    result.fold(
      (failure) => emit(CreateShipmentsError(message: failure.message)),
      (message) => emit(CreateShipmentsLoaded(message: message)),
    );
  }

  Future<void> createPrepareShipments({
    required DateTime shippedAt,
    required DateTime estimatedAt,
    required DropdownEntity nextWarehouse,
    required DropdownEntity transportMode,
    required String batchName,
    required Map<String, Set<String>> selectedCodes,
  }) async {
    emit(CreateShipmentsLoading());

    final uniqueCodes = selectedCodes.values.expand((codes) => codes).toList();
    final params = CreatePrepareShipmentsUseCaseParams(
      shippedAt: shippedAt,
      estimatedAt: estimatedAt,
      nextWarehouse: nextWarehouse,
      transportMode: transportMode,
      batchName: batchName,
      uniqueCodes: uniqueCodes,
    );
    final result = await _createPrepareShipmentsUseCase(params);

    result.fold(
      (failure) => emit(CreateShipmentsError(message: failure.message)),
      (message) => emit(CreateShipmentsLoaded(message: message)),
    );
  }

  Future<void> createReceiveShipments(
      {required DateTime receivedAt,
      required List<UHFResultEntity> uhfresults}) async {
    emit(CreateShipmentsLoading());

    final uniqueCodes = uhfresults.map((e) => e.epcId).toList();
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

  Future<void> deletePreparedShipments({required String shipmentId}) async {
    emit(DeleteShipmentsLoading());

    final result = await _deletePreparedShipmentsUseCase(shipmentId);

    result.fold(
      (failure) => emit(DeleteShipmentsError(message: failure.message)),
      (message) => emit(DeleteShipmentsLoaded(message: message)),
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

  Future<void> fetchGoodTimeline({required String receiptNumber}) async {
    emit(FetchGoodTimelineLoading());

    final result = await _fetchGoodTimelineUseCase(receiptNumber);

    result.fold(
      (failure) => emit(FetchGoodTimelineError(message: failure.message)),
      (timeline) => emit(FetchGoodTimelineLoaded(timeline: timeline)),
    );
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

  Future<void> fetchPickedGoods({String? search}) async {
    emit(FetchPickedGoodsLoading());

    final params = FetchPickedUpGoodsUseCaseParams(
      page: _currentPage = 1,
      search: search,
    );
    final result = await _fetchPickedUpGoodsUseCase(params);

    result.fold(
      (failure) => emit(FetchPickedGoodsError(message: failure.message)),
      (pickedGoods) => emit(FetchPickedGoodsLoaded(
          pickedGoods: _pickedGoods
            ..clear()
            ..addAll(pickedGoods))),
    );
  }

  Future<void> fetchPickedGoodsPaginate({String? search}) async {
    emit(ListPaginateLoading());

    final params = FetchPickedUpGoodsUseCaseParams(
      page: ++_currentPage,
      search: search,
    );
    final result = await _fetchPickedUpGoodsUseCase(params);

    result.fold(
      (failure) => emit(ListPaginateError(message: failure.message)),
      (pickedGoods) => pickedGoods.isEmpty
          ? emit(ListPaginateLast(currentPage: _currentPage = 1))
          : emit(FetchPickedGoodsLoaded(
              pickedGoods: _pickedGoods..addAll(pickedGoods))),
    );
  }

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

  Future<void> fetchPreviewDeliveryShipments(
      {required DropdownEntity nextWarehouse,
      required List<UHFResultEntity> uhfresults,
      DropdownEntity? driver}) async {
    emit(FetchPreviewBatchesShipmentsLoading());

    final uniqueCodes = uhfresults.map((e) => e.epcId).toList();
    final params = FetchPreviewDeliveryShipmentsUseCaseParams(
      nextWarehouse: nextWarehouse,
      uniqueCodes: uniqueCodes,
    );

    final result = await _fetchPreviewDeliveryShipmentsUseCase(params);

    result.fold(
      (failure) =>
          emit(FetchPreviewBatchesShipmentsError(message: failure.message)),
      (batches) => emit(FetchPreviewBatchesShipmentsLoaded(
          allBatches: batches, batches: batches)),
    );
  }

  Future<void> fetchPreviewPickUpGoods(
      {required List<UHFResultEntity> uhfResults}) async {
    emit(FetchPreviewGoodsShipmentsLoading());

    final uniqueCodes = uhfResults.map((e) => e.epcId).toList();
    final result = await _fetchPreviewPickUpGoodsUseCase(uniqueCodes);

    result.fold(
      (failure) =>
          emit(FetchPreviewGoodsShipmentsError(message: failure.message)),
      (goods) => emit(FetchPreviewGoodsShipmentsLoaded(
          goods: previewGoods
            ..clear()
            ..addAll(goods))),
    );
  }

  Future<void> fetchPreviewPrepareShipments(
      {required List<UHFResultEntity> uhfresults}) async {
    emit(FetchPreviewGoodsShipmentsLoading());

    final uniqueCodes = uhfresults.map((e) => e.epcId).toList();
    final result = await _fetchPreviewPrepareShipmentsUseCase(uniqueCodes);

    result.fold(
      (failure) =>
          emit(FetchPreviewGoodsShipmentsError(message: failure.message)),
      (goods) => emit(FetchPreviewGoodsShipmentsLoaded(
          goods: previewGoods
            ..clear()
            ..addAll(goods))),
    );
  }

  Future<void> fetchPreviewReceiveShipments(
      {required DropdownEntity origin,
      required List<UHFResultEntity> uhfresults}) async {
    emit(FetchPreviewBatchesShipmentsLoading());

    final uniqueCodes = uhfresults.map((e) => e.epcId).toList();
    final params = FetchPreviewReceiveShipmentsUseCaseParams(
      origin: origin,
      uniqueCodes: uniqueCodes,
    );

    final result = await _fetchPreviewReceiveShipmentsUseCase(params);

    result.fold(
      (failure) =>
          emit(FetchPreviewBatchesShipmentsError(message: failure.message)),
      (batches) => emit(FetchPreviewBatchesShipmentsLoaded(
          allBatches: batches, batches: batches)),
    );
  }

  Future<void> fetchReceiveShipments({String? search}) async {
    emit(FetchReceiveShipmentsLoading());

    final params = FetchReceiveShipmentsUseCaseParams(
      page: 1,
      search: search,
    );
    final result = await _fetchReceiveShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchReceiveShipmentsError(message: failure.message)),
      (batches) => emit(FetchReceiveShipmentsLoaded(batches: batches)),
    );
  }

  Future<void> fetchReceiveShipmentsPaginate({String? search}) async {
    final currentState = state;
    if (currentState is! FetchReceiveShipmentsLoaded) return;
    if (currentState.isLastPage) return;

    final params = FetchReceiveShipmentsUseCaseParams(
      page: currentState.currentPage + 1,
      search: search,
    );
    final result = await _fetchReceiveShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchReceiveShipmentsError(message: failure.message)),
      (batches) => batches.isEmpty
          ? emit(currentState.copyWithPage(isLastPage: true))
          : emit(currentState.copyWith(
              batches: [...currentState.batches, ...batches],
              currentPage: currentState.currentPage + 1,
              isLastPage: false,
            )),
    );
  }

  void searchBatches(String keyword) {
    final currentState = state;
    if (currentState is! FetchPreviewBatchesShipmentsLoaded) return;

    final filteredBatches = <BatchEntity>[];
    if (keyword.isEmpty) {
      filteredBatches.addAll(currentState.allBatches);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      final results = currentState.allBatches.where(
        (batch) {
          final batchNameMatch =
              batch.name.toLowerCase().contains(lowerKeyword);
          final trackingNumberMatch =
              batch.trackingNumber.toLowerCase().contains(lowerKeyword);

          return batchNameMatch || trackingNumberMatch;
        },
      ).toList();
      filteredBatches.addAll(results);
    }

    emit(currentState.copyWith(batches: filteredBatches));
  }

  void searchReceiptNumbers(BatchEntity selectedBatch, [String keyword = '']) {
    final currentState = state;
    if (currentState is! ReceiptNumberSearchableState) return;

    final filteredReceiptNumbers = <GoodEntity>[];
    if (keyword.isEmpty) {
      filteredReceiptNumbers.addAll(selectedBatch.goods);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      final results = selectedBatch.goods
          .where(
              (good) => good.receiptNumber.toLowerCase().contains(lowerKeyword))
          .toList();
      filteredReceiptNumbers.addAll(results);
    }

    emit(currentState.copyWithGoods(goods: filteredReceiptNumbers));
  }

  void onUHFScan() => emit(OnUHFScan());
  void qrCodeScan() => emit(QRCodeScan());
  void resetUHFScan() => emit(ResetUHFScan());
  void resetState() => emit(InventoryInitial());
}
