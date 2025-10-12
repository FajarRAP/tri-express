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
    implements FetchPreviewShipments {
  const FetchPreviewShipmentsLoaded({
    required super.data,
    required this.filteredData,
  });

  final List<BatchEntity> filteredData;

  @override
  FetchPreviewShipmentsLoaded copyWith({
    List<BatchEntity>? data,
    List<BatchEntity>? filteredData,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
  }) {
    return FetchPreviewShipmentsLoaded(
      data: data ?? this.data,
      filteredData: filteredData ?? this.filteredData,
    );
  }

  @override
  List<Object> get props => [data, filteredData];
}

class FetchPreviewShipmentsError extends Error<List<BatchEntity>>
    implements FetchPreviewShipments {
  const FetchPreviewShipmentsError(super.failure);
}
