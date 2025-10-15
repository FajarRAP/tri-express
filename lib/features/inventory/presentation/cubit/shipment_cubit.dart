import 'package:bloc/bloc.dart';

import '../../../../core/use_case/use_case.dart';
import '../../../../core/utils/states.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/lost_good_entity.dart';
import '../../domain/entities/timeline_summary_entity.dart';
import '../../domain/use_cases/fetch_good_timeline_use_case.dart';
import '../../domain/use_cases/fetch_inventories_count_use_case.dart';
import '../../domain/use_cases/fetch_inventories_use_case.dart';
import '../../domain/use_cases/fetch_lost_good_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';

part 'shipment_state.dart';

class ShipmentCubit extends Cubit<ReusableState> {
  ShipmentCubit({
    required FetchOnTheWayShipmentsUseCase fetchOnTheWayShipmentsUseCase,
    required FetchInventoriesUseCase fetchInventoriesUseCase,
    required FetchInventoriesCountUseCase fetchInventoriesCountUseCase,
    required FetchGoodTimelineUseCase fetchGoodTimelineUseCase,
    required FetchLostGoodUseCase fetchLostGoodUseCase,
  })  : _fetchOnTheWayShipmentsUseCase = fetchOnTheWayShipmentsUseCase,
        _fetchInventoriesUseCase = fetchInventoriesUseCase,
        _fetchInventoriesCountUseCase = fetchInventoriesCountUseCase,
        _fetchGoodTimelineUseCase = fetchGoodTimelineUseCase,
        _fetchLostGoodUseCase = fetchLostGoodUseCase,
        super(Initial());

  final FetchOnTheWayShipmentsUseCase _fetchOnTheWayShipmentsUseCase;
  final FetchInventoriesUseCase _fetchInventoriesUseCase;
  final FetchInventoriesCountUseCase _fetchInventoriesCountUseCase;
  final FetchGoodTimelineUseCase _fetchGoodTimelineUseCase;
  final FetchLostGoodUseCase _fetchLostGoodUseCase;

  Future<void> fetchOnTheWayShipments({String? search}) async {
    emit(FetchShipmentsLoading());

    final params = FetchOnTheWayShipmentsUseCaseParams(
      page: 1,
      search: search,
    );
    final result = await _fetchOnTheWayShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentsError(failure)),
      (batches) => emit(FetchShipmentsLoaded(data: batches)),
    );
  }

  Future<void> fetchOnTheWayShipmentsPaginate({String? search}) async {
    final currentState = state;
    if (currentState is! FetchShipmentsLoaded) return;
    if (currentState.hasReachedMax) return;

    final params = FetchOnTheWayShipmentsUseCaseParams(
      page: currentState.currentPage + 1,
      search: search,
    );
    final result = await _fetchOnTheWayShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentsError(failure)),
      (batches) => batches.isEmpty
          ? emit(currentState.copyWith(hasReachedMax: true))
          : emit(currentState.copyWith(
              data: [...currentState.data, ...batches],
              currentPage: currentState.currentPage + 1)),
    );
  }

  Future<void> fetchInventories({String? search}) async {
    emit(FetchInventoriesLoading());

    final params = FetchInventoriesUseCaseParams(
      page: 1,
      search: search,
    );
    final (inventories, count) = await (
      _fetchInventoriesUseCase(params),
      _fetchInventoriesCountUseCase(NoParams())
    ).wait;

    inventories.fold(
      (failure) => emit(FetchInventoriesError(failure)),
      (goods) => emit(FetchInventoriesLoaded(
          data: goods, totalAllUnits: count.getOrElse((_) => 0))),
    );
  }

  Future<void> fetchInventoriesPaginate({String? search}) async {
    final currentState = state;
    if (currentState is! FetchInventoriesLoaded) return;
    if (currentState.hasReachedMax) return;

    final params = FetchInventoriesUseCaseParams(
      page: currentState.currentPage + 1,
      search: search,
    );
    final result = await _fetchInventoriesUseCase(params);

    result.fold(
      (failure) => emit(FetchInventoriesError(failure)),
      (batches) => batches.isEmpty
          ? emit(currentState.copyWith(hasReachedMax: true))
          : emit(currentState.copyWith(
              data: [...currentState.data, ...batches],
              currentPage: currentState.currentPage + 1)),
    );
  }

  Future<void> fetchGoodTimeline({required String receiptNumber}) async {
    emit(Loading<TimelineSummaryEntity>());

    final result = await _fetchGoodTimelineUseCase(receiptNumber);

    result.fold(
      (failure) => emit(Error<TimelineSummaryEntity>(failure)),
      (timeline) => emit(Loaded<TimelineSummaryEntity>(data: timeline)),
    );
  }

  Future<void> fetchLostGoods(String uniqueCode) async {
    emit(Loading<LostGoodEntity>());

    final result = await _fetchLostGoodUseCase(uniqueCode);

    result.fold(
      (failure) => emit(Error<LostGoodEntity>(failure)),
      (lostGood) => emit(Loaded<LostGoodEntity>(data: lostGood)),
    );
  }
}
