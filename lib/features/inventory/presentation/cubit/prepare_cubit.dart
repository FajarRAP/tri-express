import 'package:bloc/bloc.dart';

import '../../../../core/utils/states.dart';
import '../../../core/domain/entities/dropdown_entity.dart';
import '../../../core/domain/entities/uhf_result_entity.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/use_cases/create_prepare_shipments_use_case.dart';
import '../../domain/use_cases/delete_prepared_shipments_use_case.dart';
import '../../domain/use_cases/fetch_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_prepare_shipments_use_case.dart';
import 'mixins/preview_good_mixin.dart';

part 'prepare_state.dart';

class PrepareCubit extends Cubit<ReusableState<List>> with PreviewGoodMixin {
  PrepareCubit({
    required CreatePrepareShipmentsUseCase createPrepareShipmentsUseCase,
    required DeletePreparedShipmentsUseCase deletePreparedShipmentsUseCase,
    required FetchPrepareShipmentsUseCase fetchPrepareShipmentsUseCase,
    required FetchPreviewPrepareShipmentsUseCase
        fetchPreviewPrepareShipmentsUseCase,
  })  : _createPrepareShipmentsUseCase = createPrepareShipmentsUseCase,
        _deletePreparedShipmentsUseCase = deletePreparedShipmentsUseCase,
        _fetchPrepareShipmentsUseCase = fetchPrepareShipmentsUseCase,
        _fetchPreviewPrepareShipmentsUseCase =
            fetchPreviewPrepareShipmentsUseCase,
        super(Initial());

  final CreatePrepareShipmentsUseCase _createPrepareShipmentsUseCase;
  final DeletePreparedShipmentsUseCase _deletePreparedShipmentsUseCase;
  final FetchPrepareShipmentsUseCase _fetchPrepareShipmentsUseCase;
  final FetchPreviewPrepareShipmentsUseCase
      _fetchPreviewPrepareShipmentsUseCase;

  Future<void> createPrepareShipments({
    required DateTime shippedAt,
    required DateTime estimatedAt,
    required DropdownEntity nextWarehouse,
    required DropdownEntity transportMode,
    required String batchName,
    required Map<String, Set<String>> selectedCodes,
  }) async {
    emit(ActionInProgress());

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
      (failure) => emit(ActionFailure(failure)),
      (message) => emit(ActionSuccess(message)),
    );
  }

  Future<void> deletePreparedShipments({required String shipmentId}) async {
    emit(ActionInProgress());

    final result = await _deletePreparedShipmentsUseCase(shipmentId);

    result.fold(
      (failure) => emit(ActionFailure(failure)),
      (message) => emit(ActionSuccess(message)),
    );
  }

  Future<void> fetchPrepareShipments({String? search}) async {
    emit(FetchShipmentsLoading());

    final params = FetchPrepareShipmentsUseCaseParams(
      page: 1,
      search: search,
    );
    final result = await _fetchPrepareShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentsError(failure)),
      (batches) => emit(FetchShipmentsLoaded(data: batches)),
    );
  }

  Future<void> fetchPrepareShipmentsPaginate({String? search}) async {
    final currentState = state;
    if (currentState is! FetchShipmentsLoaded) return;
    if (currentState.hasReachedMax) return;

    final params = FetchPrepareShipmentsUseCaseParams(
      page: currentState.currentPage + 1,
      search: search,
    );
    final result = await _fetchPrepareShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentsError(failure)),
      (batches) => batches.isEmpty
          ? emit(currentState.copyWith(hasReachedMax: true))
          : emit(currentState.copyWith(
              data: [...currentState.data, ...batches],
              currentPage: currentState.currentPage + 1)),
    );
  }

  Future<void> fetchPreviewPrepareShipments(
      {required List<UHFResultEntity> uhfresults}) async {
    emit(FetchPreviewShipmentsLoading());

    final uniqueCodes = uhfresults.map((e) => e.epcId).toList();
    final result = await _fetchPreviewPrepareShipmentsUseCase(uniqueCodes);

    result.fold(
      (failure) => emit(FetchPreviewShipmentsError(failure)),
      (goods) =>
          emit(FetchPreviewShipmentsLoaded(data: goods, filteredGoods: goods)),
    );
  }

  void resetState() => emit(Initial());
}
