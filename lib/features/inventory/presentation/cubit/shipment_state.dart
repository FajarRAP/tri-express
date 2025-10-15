part of 'shipment_cubit.dart';

class ShipmentState<T> extends ReusableState<T> {
  const ShipmentState();
}

class FetchShipments extends ShipmentState<List<BatchEntity>> {}

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
    int? totalAllUnits,
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

class FetchInventories extends ShipmentState<List<LostGoodEntity>> {}

class FetchInventoriesLoading extends Loading<List<LostGoodEntity>>
    implements FetchInventories {}

class FetchInventoriesLoaded extends Loaded<List<LostGoodEntity>>
    implements FetchInventories {
  const FetchInventoriesLoaded({
    required super.data,
    super.currentPage = 1,
    super.hasReachedMax = false,
    super.isPaginating = false,
    this.totalAllUnits = 0,
  });

  final int totalAllUnits;

  @override
  FetchInventoriesLoaded copyWith({
    List<LostGoodEntity>? data,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
    int? totalAllUnits,
  }) {
    return FetchInventoriesLoaded(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      totalAllUnits: totalAllUnits ?? this.totalAllUnits,
    );
  }

  @override
  List<Object?> get props =>
      [data, currentPage, hasReachedMax, isPaginating, totalAllUnits];
}

class FetchInventoriesError extends Error<List<LostGoodEntity>>
    implements FetchInventories {
  const FetchInventoriesError(super.failure);
}
