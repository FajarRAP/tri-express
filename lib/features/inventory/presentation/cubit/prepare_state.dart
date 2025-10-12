part of 'prepare_cubit.dart';

class PrepareState<T> extends ReusableState<T> {
  const PrepareState();
}

class FetchShipments extends PrepareState<List<BatchEntity>> {}

class FetchShipmentsLoading extends Loading<List<BatchEntity>>
    implements FetchShipments {}

class FetchShipmentsLoaded extends Loaded<List<BatchEntity>>
    implements FetchShipments {
  const FetchShipmentsLoaded({
    required super.data,
    super.currentPage = 1,
    super.hasReachedMax = false,
    super.isPaginating = false,
  });

  @override
  FetchShipmentsLoaded copyWith({
    List<BatchEntity>? data,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
  }) {
    return FetchShipmentsLoaded(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }

  @override
  List<Object> get props => [data, currentPage, hasReachedMax, isPaginating];
}

class FetchShipmentsError extends Error<List<BatchEntity>>
    implements FetchShipments {
  const FetchShipmentsError(super.failure);
}

class FetchPreviewShipments extends PrepareState<List<GoodEntity>> {}

class FetchPreviewShipmentsLoading extends Loading<List<GoodEntity>>
    implements FetchPreviewShipments {}

class FetchPreviewShipmentsLoaded extends Loaded<List<GoodEntity>>
    implements FetchPreviewShipments, GoodSearchableState {
  const FetchPreviewShipmentsLoaded({
    required super.data,
    this.filteredGoods = const [],
  });

  @override
  List<GoodEntity> get allGoods => data;
  @override
  final List<GoodEntity> filteredGoods;

  @override
  FetchPreviewShipmentsLoaded copyWith({
    List<GoodEntity>? data,
    List<GoodEntity>? filteredGoods,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
  }) {
    return FetchPreviewShipmentsLoaded(
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
  List<Object> get props => [data, filteredGoods];
}

class FetchPreviewShipmentsError extends Error<List<GoodEntity>>
    implements FetchPreviewShipments {
  const FetchPreviewShipmentsError(super.failure);
}
