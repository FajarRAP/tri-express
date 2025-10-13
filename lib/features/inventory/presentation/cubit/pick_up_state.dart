part of 'pick_up_cubit.dart';

class PickUpState<T> extends ReusableState<T> {
  const PickUpState();
}

class FetchGoods extends PickUpState<List<PickedGoodEntity>> {
  const FetchGoods();
}

class FetchGoodsLoading extends Loading<List<PickedGoodEntity>>
    implements FetchGoods {}

class FetchGoodsLoaded extends Loaded<List<PickedGoodEntity>>
    implements FetchGoods {
  const FetchGoodsLoaded({
    required super.data,
    super.currentPage = 1,
    super.hasReachedMax = false,
    super.isPaginating = false,
  });

  @override
  FetchGoodsLoaded copyWith({
    List<PickedGoodEntity>? data,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
  }) {
    return FetchGoodsLoaded(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }

  @override
  List<Object?> get props => [data, currentPage, hasReachedMax, isPaginating];
}

class FetchGoodsError extends Error<List<PickedGoodEntity>>
    implements FetchGoods {
  const FetchGoodsError(super.failure);
}

class FetchPreviewGoods extends PickUpState<List<GoodEntity>> {
  const FetchPreviewGoods();
}

class FetchPreviewGoodsLoading extends Loading<List<GoodEntity>>
    implements FetchPreviewGoods {}

class FetchPreviewGoodsLoaded extends Loaded<List<GoodEntity>>
    implements FetchPreviewGoods, GoodSearchableState {
  const FetchPreviewGoodsLoaded({
    required super.data,
    this.filteredGoods = const [],
  });

  @override
  List<GoodEntity> get allGoods => data;
  @override
  final List<GoodEntity> filteredGoods;

  @override
  FetchPreviewGoodsLoaded copyWith({
    List<GoodEntity>? data,
    List<GoodEntity>? filteredGoods,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
  }) {
    return FetchPreviewGoodsLoaded(
      data: data ?? this.data,
      filteredGoods: filteredGoods ?? this.filteredGoods,
    );
  }

  @override
  GoodSearchableState copyWithFiltered(
      {List<GoodEntity>? allGoods, required List<GoodEntity> filteredGoods}) {
    return copyWith(
      data: allGoods ?? this.data,
      filteredGoods: filteredGoods,
    );
  }

  @override
  List<Object?> get props => [data, filteredGoods];
}

class FetchPreviewGoodsError extends Error<List<GoodEntity>>
    implements FetchPreviewGoods {
  const FetchPreviewGoodsError(super.failure);
}
