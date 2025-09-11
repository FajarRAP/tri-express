part of 'inventory_cubit.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}

class ListPaginate extends InventoryState {}

class FetchDeliveryGoods extends InventoryState {}

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

class FetchDeliveryGoodsLoading extends FetchDeliveryGoods {}

class FetchDeliveryGoodsLoaded extends FetchDeliveryGoods {
  FetchDeliveryGoodsLoaded({required this.batches});

  final List<BatchEntity> batches;
}

class FetchDeliveryGoodsError extends FetchDeliveryGoods {
  FetchDeliveryGoodsError({required this.message});

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
