part of 'inventory_cubit.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}

class ListPaginate extends InventoryState {}

class FetchDeliveryShipments extends InventoryState {}

class FetchReceiveShipments extends InventoryState {}

class FetchPrepareShipments extends InventoryState {}

class FetchPickUpShipments extends InventoryState {}

class FetchShipmentReceiptNumbers extends InventoryState {}

class ListPaginateLoading extends ListPaginate {}

class ListPaginateLoaded extends ListPaginate {}

class ListPaginateLast extends ListPaginate {
  ListPaginateLast({required this.currentPage});

  final int currentPage;
}

class ListPaginateError extends ListPaginate {
  ListPaginateError({required this.message});

  final String message;
}

class FetchDeliveryShipmentsLoading extends FetchDeliveryShipments {}

class FetchDeliveryShipmentsLoaded extends FetchDeliveryShipments {
  FetchDeliveryShipmentsLoaded({required this.batches});

  final List<BatchEntity> batches;
}

class FetchDeliveryShipmentsError extends FetchDeliveryShipments {
  FetchDeliveryShipmentsError({required this.message});

  final String message;
}

class FetchShipmentReceiptNumbersLoading extends FetchShipmentReceiptNumbers {}

class FetchShipmentReceiptNumbersLoaded extends FetchShipmentReceiptNumbers {
  FetchShipmentReceiptNumbersLoaded({required this.receiptNumbers});

  final List<String> receiptNumbers;
}

class FetchShipmentReceiptNumbersError extends FetchShipmentReceiptNumbers {
  FetchShipmentReceiptNumbersError({required this.message});

  final String message;
}

class FetchReceiveShipmentsLoading extends FetchReceiveShipments {}

class FetchReceiveShipmentsLoaded extends FetchReceiveShipments {
  FetchReceiveShipmentsLoaded({required this.batches});

  final List<BatchEntity> batches;
}

class FetchReceiveShipmentsError extends FetchReceiveShipments {
  FetchReceiveShipmentsError({required this.message});

  final String message;
}

class FetchPrepareShipmentsLoading extends FetchPrepareShipments {}

class FetchPrepareShipmentsLoaded extends FetchPrepareShipments {
  FetchPrepareShipmentsLoaded({required this.batches});

  final List<BatchEntity> batches;
}

class FetchPrepareShipmentsError extends FetchPrepareShipments {
  FetchPrepareShipmentsError({required this.message});

  final String message;
}

class FetchPickUpShipmentsLoading extends FetchPickUpShipments {}

class FetchPickUpShipmentsLoaded extends FetchPickUpShipments {
  FetchPickUpShipmentsLoaded({required this.batches});

  final List<BatchEntity> batches;
}

class FetchPickUpShipmentsError extends FetchPickUpShipments {
  FetchPickUpShipmentsError({required this.message});

  final String message;
}
