import 'package:bloc/bloc.dart';

import '../../../../core/utils/states.dart';
import '../../../core/domain/entities/uhf_result_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/entities/picked_good_entity.dart';
import '../../domain/use_cases/create_picked_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_picked_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_preview_pick_up_goods_use_case.dart';
import 'mixins/preview_good_mixin.dart';

part 'pick_up_state.dart';

class PickUpCubit extends Cubit<ReusableState> with PreviewGoodMixin {
  PickUpCubit({
    required FetchPickedUpGoodsUseCase fetchPickedUpGoodsUseCase,
    required FetchPreviewPickUpGoodsUseCase fetchPreviewPickUpGoodsUseCase,
    required CreatePickedUpGoodsUseCase createPickedUpGoodsUseCase,
  })  : _fetchPickedUpGoodsUseCase = fetchPickedUpGoodsUseCase,
        _fetchPreviewPickUpGoodsUseCase = fetchPreviewPickUpGoodsUseCase,
        _createPickedUpGoodsUseCase = createPickedUpGoodsUseCase,
        super(Initial());

  final FetchPickedUpGoodsUseCase _fetchPickedUpGoodsUseCase;
  final FetchPreviewPickUpGoodsUseCase _fetchPreviewPickUpGoodsUseCase;
  final CreatePickedUpGoodsUseCase _createPickedUpGoodsUseCase;

  Future<void> createPickedUpGoods(
      {required Map<String, Set<String>> selectedCodes,
      required String note,
      required String pickedImagePath,
      required DateTime pickedUpAt}) async {
    emit(ActionInProgress());

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
      (failure) => emit(ActionFailure(failure)),
      (message) => emit(ActionSuccess(message)),
    );
  }

  Future<void> fetchPickedGoods({String? search}) async {
    emit(FetchGoodsLoading());

    final params = FetchPickedUpGoodsUseCaseParams(
      page: 1,
      search: search,
    );
    final result = await _fetchPickedUpGoodsUseCase(params);

    result.fold(
      (failure) => emit(FetchGoodsError(failure)),
      (pickedGoods) => emit(FetchGoodsLoaded(data: pickedGoods)),
    );
  }

  Future<void> fetchPickedGoodsPaginate({String? search}) async {
    final currentState = state;
    if (currentState is! FetchGoodsLoaded) return;
    if (currentState.hasReachedMax) return;

    final params = FetchPickedUpGoodsUseCaseParams(
      page: currentState.currentPage + 1,
      search: search,
    );
    final result = await _fetchPickedUpGoodsUseCase(params);

    result.fold(
      (failure) => emit(FetchGoodsError(failure)),
      (pickedGoods) => pickedGoods.isEmpty
          ? emit(currentState.copyWith(hasReachedMax: true))
          : emit(currentState.copyWith(
              data: [...currentState.data, ...pickedGoods],
              currentPage: currentState.currentPage + 1)),
    );
  }

  Future<void> fetchPreviewPickUpGoods(
      {required List<UHFResultEntity> uhfResults}) async {
    emit(FetchPreviewGoodsLoading());

    final uniqueCodes = uhfResults.map((e) => e.epcId).toList();
    final result = await _fetchPreviewPickUpGoodsUseCase(uniqueCodes);

    result.fold(
      (failure) => emit(FetchPreviewGoodsError(failure)),
      (goods) =>
          emit(FetchPreviewGoodsLoaded(data: goods, filteredGoods: goods)),
    );
  }

  void resetState() => emit(Initial());
}
