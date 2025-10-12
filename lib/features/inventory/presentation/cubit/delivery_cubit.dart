import 'package:bloc/bloc.dart';

import '../../../../core/utils/states.dart';
import '../../../core/domain/entities/dropdown_entity.dart';
import '../../../core/domain/entities/uhf_result_entity.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/use_cases/create_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_delivery_shipments_use_case.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<ReusableState<List<BatchEntity>>> {
  DeliveryCubit({
    required CreateDeliveryShipmentsUseCase createDeliveryShipmentsUseCase,
    required FetchDeliveryShipmentsUseCase fetchDeliveryShipmentsUseCase,
    required FetchPreviewDeliveryShipmentsUseCase
        fetchPreviewDeliveryShipmentsUseCase,
  })  : _createDeliveryShipmentsUseCase = createDeliveryShipmentsUseCase,
        _fetchDeliveryShipmentsUseCase = fetchDeliveryShipmentsUseCase,
        _fetchPreviewDeliveryShipmentsUseCase =
            fetchPreviewDeliveryShipmentsUseCase,
        super(Initial());

  final CreateDeliveryShipmentsUseCase _createDeliveryShipmentsUseCase;
  final FetchDeliveryShipmentsUseCase _fetchDeliveryShipmentsUseCase;
  final FetchPreviewDeliveryShipmentsUseCase
      _fetchPreviewDeliveryShipmentsUseCase;

  Future<void> createDeliveryShipments({
    required DropdownEntity nextWarehouse,
    required DropdownEntity driver,
    required Set<BatchEntity> batches,
    required DateTime deliveredAt,
  }) async {
    emit(ActionInProgress());

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
      (failure) => emit(ActionFailure(failure)),
      (message) => emit(ActionSuccess(message)),
    );
  }

  Future<void> fetchDeliveryShipments({String? search}) async {
    emit(FetchShipmentsLoading());

    final params = FetchDeliveryShipmentsUseCaseParams(
      page: 1,
      search: search,
    );
    final result = await _fetchDeliveryShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentsError(failure)),
      (batches) => emit(FetchShipmentsLoaded(data: batches)),
    );
  }

  Future<void> fetchDeliveryShipmentsPaginate({String? search}) async {
    final currentState = state;
    if (currentState is! Loaded<List<BatchEntity>>) return;
    if (currentState.hasReachedMax) return;

    final params = FetchDeliveryShipmentsUseCaseParams(
      page: currentState.currentPage + 1,
      search: search,
    );
    final result = await _fetchDeliveryShipmentsUseCase(params);

    result.fold(
        (failure) => emit(Error(failure)),
        (batches) => batches.isEmpty
            ? emit(currentState.copyWith(hasReachedMax: true))
            : emit(currentState.copyWith(
                data: [...currentState.data, ...batches],
                currentPage: currentState.currentPage + 1)));
  }

  Future<void> fetchPreviewDeliveryShipments(
      {required DropdownEntity nextWarehouse,
      required List<UHFResultEntity> uhfresults,
      DropdownEntity? driver}) async {
    emit(FetchPreviewShipmentsLoading());

    final uniqueCodes = uhfresults.map((e) => e.epcId).toList();
    final params = FetchPreviewDeliveryShipmentsUseCaseParams(
      nextWarehouse: nextWarehouse,
      uniqueCodes: uniqueCodes,
    );

    final result = await _fetchPreviewDeliveryShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchPreviewShipmentsError(failure)),
      (batches) => emit(
          FetchPreviewShipmentsLoaded(data: batches, filteredData: batches)),
    );
  }

  void searchBatches(String keyword) {
    final currentState = state;
    if (currentState is! FetchPreviewShipmentsLoaded) return;

    final filteredBatches = <BatchEntity>[];
    if (keyword.isEmpty) {
      filteredBatches.addAll(currentState.data);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      final results = currentState.data.where(
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

    emit(currentState.copyWith(filteredData: filteredBatches));
  }

  void clearPreviewBatches() {
    final currentState = state;
    if (currentState is! FetchPreviewShipmentsLoaded) return;

    emit(currentState.copyWith(data: [], filteredData: []));
  }
}
