part of 'inventory_cubit.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}

class ListPaginate extends InventoryState {}

class FetchDeliveryShipments extends InventoryState {}

class FetchInventories extends InventoryState {}

class FetchInventoriesCount extends InventoryState {}

class FetchOnTheWayShipments extends InventoryState {}

class FetchPreviewReceiveShipments extends InventoryState {}

class FetchPreviewPrepareShipments extends InventoryState {}

class FetchPickUpShipments extends InventoryState {}

class FetchPrepareShipments extends InventoryState {}

class FetchReceiveShipments extends InventoryState {}

class FetchShipmentReceiptNumbers extends InventoryState {}

class CreateShipments extends InventoryState {}

class DeleteShipments extends InventoryState {}

class UHFAction extends InventoryState {}

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

class FetchOnTheWayShipmentsLoading extends FetchOnTheWayShipments {}

class FetchOnTheWayShipmentsLoaded extends FetchOnTheWayShipments {
  FetchOnTheWayShipmentsLoaded({required this.batches});

  final List<BatchEntity> batches;
}

class FetchOnTheWayShipmentsError extends FetchOnTheWayShipments {
  FetchOnTheWayShipmentsError({required this.message});

  final String message;
}

class FetchInventoriesLoading extends FetchInventories {}

class FetchInventoriesLoaded extends FetchInventories {
  FetchInventoriesLoaded({required this.batches});

  final List<BatchEntity> batches;
}

class FetchInventoriesError extends FetchInventories {
  FetchInventoriesError({required this.message});

  final String message;
}

class FetchInventoriesCountLoading extends FetchInventoriesCount {}

class FetchInventoriesCountLoaded extends FetchInventoriesCount {
  FetchInventoriesCountLoaded({required this.count});

  final int count;
}

class FetchInventoriesCountError extends FetchInventoriesCount {
  FetchInventoriesCountError({required this.message});

  final String message;
}

class FetchPreviewReceiveShipmentsLoading
    extends FetchPreviewReceiveShipments {}

class FetchPreviewReceiveShipmentsLoaded extends FetchPreviewReceiveShipments {
  FetchPreviewReceiveShipmentsLoaded({required this.batches});

  final List<BatchEntity> batches;
}

class FetchPreviewReceiveShipmentsError extends FetchPreviewReceiveShipments {
  FetchPreviewReceiveShipmentsError({required this.message});
  final String message;
}

class FetchPreviewPrepareShipmentsLoading
    extends FetchPreviewPrepareShipments {}

class FetchPreviewPrepareShipmentsLoaded extends FetchPreviewPrepareShipments {
  FetchPreviewPrepareShipmentsLoaded({required this.goods});

  final List<GoodEntity> goods;
}

class FetchPreviewPrepareShipmentsError extends FetchPreviewPrepareShipments {
  FetchPreviewPrepareShipmentsError({required this.message});

  final String message;
}

class CreateShipmentsLoading extends CreateShipments {}

class CreateShipmentsLoaded extends CreateShipments {
  CreateShipmentsLoaded({required this.message});

  final String message;
}

class CreateShipmentsError extends CreateShipments {
  CreateShipmentsError({required this.message});

  final String message;
}

class DeleteShipmentsLoading extends DeleteShipments {}

class DeleteShipmentsLoaded extends DeleteShipments {
  DeleteShipmentsLoaded({required this.message});

  final String message;
}

class DeleteShipmentsError extends DeleteShipments {
  DeleteShipmentsError({required this.message});

  final String message;
}

class ResetUHFScan extends UHFAction {}

class OnUHFScan extends UHFAction {}

class QRCodeScan extends UHFAction {}
