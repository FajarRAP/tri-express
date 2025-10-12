import 'package:bloc/bloc.dart';

import '../../../../core/utils/states.dart';
import '../../../core/domain/entities/dropdown_entity.dart';
import '../../../core/domain/entities/uhf_result_entity.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/use_cases/create_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';
import 'mixins/preview_batch_mixin.dart';

part 'receive_state.dart';

class ReceiveCubit extends Cubit<ReusableState<List<BatchEntity>>>
    with PreviewBatchMixin {
  ReceiveCubit({
    required CreateReceiveShipmentsUseCase createReceiveShipmentsUseCase,
    required FetchReceiveShipmentsUseCase fetchReceiveShipmentsUseCase,
    required FetchPreviewReceiveShipmentsUseCase
        fetchPreviewReceiveShipmentsUseCase,
  })  : _createReceiveShipmentsUseCase = createReceiveShipmentsUseCase,
        _fetchReceiveShipmentsUseCase = fetchReceiveShipmentsUseCase,
        _fetchPreviewReceiveShipmentsUseCase =
            fetchPreviewReceiveShipmentsUseCase,
        super(Initial());

  final CreateReceiveShipmentsUseCase _createReceiveShipmentsUseCase;
  final FetchPreviewReceiveShipmentsUseCase
      _fetchPreviewReceiveShipmentsUseCase;
  final FetchReceiveShipmentsUseCase _fetchReceiveShipmentsUseCase;

  Future<void> createReceiveShipments(
      {required DateTime receivedAt,
      required List<UHFResultEntity> uhfresults}) async {
    emit(ActionInProgress());

    final uniqueCodes = uhfresults.map((e) => e.epcId).toList();
    final params = CreateReceiveShipmentsUseCaseParams(
      receivedAt: receivedAt,
      uniqueCodes: uniqueCodes,
    );
    final result = await _createReceiveShipmentsUseCase(params);

    result.fold(
      (failure) => emit(ActionFailure(failure)),
      (message) => emit(ActionSuccess(message)),
    );
  }

  Future<void> fetchReceiveShipments({String? search}) async {
    emit(FetchShipmentsLoading());

    final params = FetchReceiveShipmentsUseCaseParams(
      page: 1,
      search: search,
    );
    final result = await _fetchReceiveShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentsError(failure)),
      (batches) => emit(FetchShipmentsLoaded(data: batches)),
    );
  }

  Future<void> fetchReceiveShipmentsPaginate({String? search}) async {
    final currentState = state;
    if (currentState is! Loaded<List<BatchEntity>>) return;
    if (currentState.hasReachedMax) return;

    final params = FetchReceiveShipmentsUseCaseParams(
      page: currentState.currentPage + 1,
      search: search,
    );
    final result = await _fetchReceiveShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentsError(failure)),
      (batches) => batches.isEmpty
          ? emit(currentState.copyWith(hasReachedMax: true))
          : emit(currentState.copyWith(
              data: [...currentState.data, ...batches],
              currentPage: currentState.currentPage + 1)),
    );
  }

  Future<void> fetchPreviewReceiveShipments(
      {required DropdownEntity origin,
      required List<UHFResultEntity> uhfresults}) async {
    emit(FetchPreviewShipmentsLoading());

    final uniqueCodes = uhfresults.map((e) => e.epcId).toList();
    final params = FetchPreviewReceiveShipmentsUseCaseParams(
      origin: origin,
      uniqueCodes: uniqueCodes,
    );

    final result = await _fetchPreviewReceiveShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchPreviewShipmentsError(failure)),
      (batches) => emit(
          FetchPreviewShipmentsLoaded(data: batches, filteredBatches: batches)),
    );
  }

  void resetState() => emit(Initial());
}
