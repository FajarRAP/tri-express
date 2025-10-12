import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/domain/entities/uhf_result_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/entities/lost_good_entity.dart';
import '../../domain/entities/picked_good_entity.dart';
import '../../domain/use_cases/create_picked_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_lost_good_use_case.dart';
import '../../domain/use_cases/fetch_picked_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_preview_pick_up_goods_use_case.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit({
    required CreatePickedUpGoodsUseCase createPickedUpGoodsUseCase,
    required FetchLostGoodUseCase fetchLostGoodUseCase,
    required FetchPickedUpGoodsUseCase fetchPickedUpGoodsUseCase,
    required FetchPreviewPickUpGoodsUseCase fetchPreviewPickUpGoodsUseCase,
  })  : _createPickedUpGoodsUseCase = createPickedUpGoodsUseCase,
        _fetchLostGoodUseCase = fetchLostGoodUseCase,
        _fetchPickedUpGoodsUseCase = fetchPickedUpGoodsUseCase,
        _fetchPreviewPickUpGoodsUseCase = fetchPreviewPickUpGoodsUseCase,
        super(InventoryInitial());

  final CreatePickedUpGoodsUseCase _createPickedUpGoodsUseCase;
  final FetchLostGoodUseCase _fetchLostGoodUseCase;
  final FetchPreviewPickUpGoodsUseCase _fetchPreviewPickUpGoodsUseCase;
  final FetchPickedUpGoodsUseCase _fetchPickedUpGoodsUseCase;

  var _currentPage = 1;
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

  Future<void> fetchLostGoods({required String uniqueCode}) async {
    emit(FetchLostGoodLoading());

    final result = await _fetchLostGoodUseCase(uniqueCode);

    result.fold(
      (failure) => emit(FetchLostGoodError(message: failure.message)),
      (lostGood) => emit(FetchLostGoodLoaded(lostGood: lostGood)),
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

  void onUHFScan() => emit(OnUHFScan());
  void qrCodeScan() => emit(QRCodeScan());
  void resetUHFScan() => emit(ResetUHFScan());
  void resetState() => emit(InventoryInitial());
}
