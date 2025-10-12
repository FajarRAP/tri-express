import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/use_case/use_case.dart';
import '../../../core/domain/entities/dropdown_entity.dart';
import '../../../core/domain/entities/uhf_result_entity.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/entities/lost_good_entity.dart';
import '../../domain/entities/picked_good_entity.dart';
import '../../domain/entities/timeline_summary_entity.dart';
import '../../domain/use_cases/create_picked_up_goods_use_case.dart';
import '../../domain/use_cases/create_prepare_shipments_use_case.dart';
import '../../domain/use_cases/delete_prepared_shipments_use_case.dart';
import '../../domain/use_cases/fetch_good_timeline_use_case.dart';
import '../../domain/use_cases/fetch_inventories_count_use_case.dart';
import '../../domain/use_cases/fetch_inventories_use_case.dart';
import '../../domain/use_cases/fetch_lost_good_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../../domain/use_cases/fetch_picked_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_pick_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_preview_prepare_shipments_use_case.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit({
    required CreatePickedUpGoodsUseCase createPickedUpGoodsUseCase,
    required CreatePrepareShipmentsUseCase createPrepareShipmentsUseCase,
    required DeletePreparedShipmentsUseCase deletePreparedShipmentsUseCase,
    required FetchGoodTimelineUseCase fetchGoodTimelineUseCase,
    required FetchInventoriesUseCase fetchInventoriesUseCase,
    required FetchInventoriesCountUseCase fetchInventoriesCountUseCase,
    required FetchLostGoodUseCase fetchLostGoodUseCase,
    required FetchOnTheWayShipmentsUseCase fetchOnTheWayShipmentsUseCase,
    required FetchPreviewPrepareShipmentsUseCase
        fetchPreviewPrepareShipmentsUseCase,
    required FetchPrepareShipmentsUseCase fetchPrepareShipmentsUseCase,
    required FetchPickedUpGoodsUseCase fetchPickedUpGoodsUseCase,
    required FetchPreviewPickUpGoodsUseCase fetchPreviewPickUpGoodsUseCase,
  })  : _createPickedUpGoodsUseCase = createPickedUpGoodsUseCase,
        _createPrepareShipmentsUseCase = createPrepareShipmentsUseCase,
        _deletePreparedShipmentsUseCase = deletePreparedShipmentsUseCase,
        _fetchGoodTimelineUseCase = fetchGoodTimelineUseCase,
        _fetchInventoriesUseCase = fetchInventoriesUseCase,
        _fetchInventoriesCountUseCase = fetchInventoriesCountUseCase,
        _fetchLostGoodUseCase = fetchLostGoodUseCase,
        _fetchOnTheWayShipmentsUseCase = fetchOnTheWayShipmentsUseCase,
        _fetchPreviewPrepareShipmentsUseCase =
            fetchPreviewPrepareShipmentsUseCase,
        _fetchPrepareShipmentsUseCase = fetchPrepareShipmentsUseCase,
        _fetchPickedUpGoodsUseCase = fetchPickedUpGoodsUseCase,
        _fetchPreviewPickUpGoodsUseCase = fetchPreviewPickUpGoodsUseCase,
        super(InventoryInitial());

  final CreatePickedUpGoodsUseCase _createPickedUpGoodsUseCase;
  final CreatePrepareShipmentsUseCase _createPrepareShipmentsUseCase;
  final DeletePreparedShipmentsUseCase _deletePreparedShipmentsUseCase;
  final FetchGoodTimelineUseCase _fetchGoodTimelineUseCase;
  final FetchInventoriesUseCase _fetchInventoriesUseCase;
  final FetchInventoriesCountUseCase _fetchInventoriesCountUseCase;
  final FetchLostGoodUseCase _fetchLostGoodUseCase;
  final FetchOnTheWayShipmentsUseCase _fetchOnTheWayShipmentsUseCase;

  final FetchPreviewPrepareShipmentsUseCase
      _fetchPreviewPrepareShipmentsUseCase;
  final FetchPreviewPickUpGoodsUseCase _fetchPreviewPickUpGoodsUseCase;
  final FetchPrepareShipmentsUseCase _fetchPrepareShipmentsUseCase;

  final FetchPickedUpGoodsUseCase _fetchPickedUpGoodsUseCase;

  var _currentPage = 1;
  final _inventories = <BatchEntity>[];
  final _onTheWayBatches = <BatchEntity>[];
  final _pickedGoods = <PickedGoodEntity>[];
  final previewGoods = <GoodEntity>[];

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

  Future<void> deletePreparedShipments({required String shipmentId}) async {
    emit(DeleteShipmentsLoading());

    final result = await _deletePreparedShipmentsUseCase(shipmentId);

    result.fold(
      (failure) => emit(DeleteShipmentsError(message: failure.message)),
      (message) => emit(DeleteShipmentsLoaded(message: message)),
    );
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

  Future<void> fetchLostGoods({required String uniqueCode}) async {
    emit(FetchLostGoodLoading());

    final result = await _fetchLostGoodUseCase(uniqueCode);

    result.fold(
      (failure) => emit(FetchLostGoodError(message: failure.message)),
      (lostGood) => emit(FetchLostGoodLoaded(lostGood: lostGood)),
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
      page: 1,
      search: search,
    );
    final result = await _fetchPrepareShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchPrepareShipmentsError(message: failure.message)),
      (batches) => emit(FetchPrepareShipmentsLoaded(
          currentPage: 1, isLastPage: batches.isEmpty, batches: batches)),
    );
  }

  Future<void> fetchPrepareShipmentsPaginate({String? search}) async {
    final currentState = state;
    if (currentState is! FetchPrepareShipmentsLoaded) return;
    if (currentState.isLastPage) return;

    final params = FetchPrepareShipmentsUseCaseParams(
      page: currentState.currentPage + 1,
      search: search,
    );
    final result = await _fetchPrepareShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchPrepareShipmentsError(message: failure.message)),
      (batches) => batches.isEmpty
          ? emit(currentState.copyWithPage(isLastPage: true))
          : emit(currentState.copyWith(
              batches: [...currentState.batches, ...batches],
              currentPage: currentState.currentPage + 1,
              isLastPage: false)),
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
      (goods) =>
          emit(FetchPreviewGoodsShipmentsLoaded(allGoods: goods, goods: goods)),
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
      (goods) =>
          emit(FetchPreviewGoodsShipmentsLoaded(allGoods: goods, goods: goods)),
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

  void searchGoods(String keyword) {
    final currentState = state;
    if (currentState is! FetchPreviewGoodsShipmentsLoaded) return;

    final filteredGoods = <GoodEntity>[];
    if (keyword.isEmpty) {
      filteredGoods.addAll(currentState.allGoods);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      final results = currentState.allGoods.where((good) {
        final nameMatch = good.name.toLowerCase().contains(lowerKeyword);
        final receiptNumberMatch =
            good.receiptNumber.toLowerCase().contains(lowerKeyword);

        return receiptNumberMatch || nameMatch;
      }).toList();
      filteredGoods.addAll(results);
    }

    emit(currentState.copyWithGoods(goods: filteredGoods));
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
  void clearPreviewedData() => switch (state) {
        final FetchPreviewBatchesShipmentsLoaded s =>
          emit(s.copyWithBatches(batches: [])),
        final FetchPreviewGoodsShipmentsLoaded s =>
          emit(s.copyWithGoods(goods: [])),
        _ => null
      };
}
