part of 'delivery_cubit.dart';

sealed class DeliveryState extends ReusableState<List<BatchEntity>> {
  const DeliveryState();
}

class FetchShipments extends DeliveryState {}

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

class FetchPreviewShipments extends DeliveryState {}

class FetchPreviewShipmentsLoading extends Loading<List<BatchEntity>>
    implements FetchPreviewShipments {}

class FetchPreviewShipmentsLoaded extends Loaded<List<BatchEntity>>
    implements FetchPreviewShipments, BatchSearchableState {
  const FetchPreviewShipmentsLoaded({
    required super.data,
    this.filteredBatches = const [],
  });

  @override
  List<BatchEntity> get allBatches => data;

  @override
  final List<BatchEntity> filteredBatches;

  @override
  FetchPreviewShipmentsLoaded copyWith({
    List<BatchEntity>? data,
    List<BatchEntity>? filteredBatches,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
  }) {
    return FetchPreviewShipmentsLoaded(
      data: data ?? this.data,
      filteredBatches: filteredBatches ?? this.filteredBatches,
    );
  }

  @override
  BatchSearchableState copyWithFiltered({
    List<BatchEntity>? allBatches,
    required List<BatchEntity> filteredBatches,
  }) {
    return copyWith(
      data: allBatches ?? this.data,
      filteredBatches: filteredBatches,
    );
  }

  @override
  List<Object> get props => [data, filteredBatches];
}

class FetchPreviewShipmentsError extends Error<List<BatchEntity>>
    implements FetchPreviewShipments {
  const FetchPreviewShipmentsError(super.failure);
}
