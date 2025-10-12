part of 'inventory_cubit.dart';

@immutable
sealed class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

abstract interface class GoodSearchableState extends InventoryState {
  List<GoodEntity> get goods;

  GoodSearchableState copyWithGoods({required List<GoodEntity> goods});
}

final class InventoryInitial extends InventoryState {}

class ListPaginate extends InventoryState {}

class FetchPreviewGoodsShipments extends InventoryState {}

class FetchShipmentReceiptNumbers extends InventoryState {}

class CreateShipments extends InventoryState {}

class DeleteShipments extends InventoryState {}

class UHFAction extends InventoryState {}

class FetchPickedGoods extends InventoryState {}

class FetchLostGood extends InventoryState {}

class ListPaginateLoading extends ListPaginate {}

class ListPaginateLoaded extends ListPaginate {}

class ListPaginateLast extends ListPaginate {
  ListPaginateLast({required this.currentPage});

  final int currentPage;

  @override
  List<Object?> get props => [currentPage];
}

class ListPaginateError extends ListPaginate {
  ListPaginateError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class FetchShipmentReceiptNumbersLoading extends FetchShipmentReceiptNumbers {}

class FetchShipmentReceiptNumbersLoaded extends FetchShipmentReceiptNumbers {
  FetchShipmentReceiptNumbersLoaded({required this.receiptNumbers});

  final List<String> receiptNumbers;

  @override
  List<Object?> get props => [receiptNumbers];
}

class FetchShipmentReceiptNumbersError extends FetchShipmentReceiptNumbers {
  FetchShipmentReceiptNumbersError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class FetchPreviewGoodsShipmentsLoading extends FetchPreviewGoodsShipments {}

class FetchPreviewGoodsShipmentsLoaded extends FetchPreviewGoodsShipments
    implements GoodSearchableState {
  FetchPreviewGoodsShipmentsLoaded({
    required this.allGoods,
    required this.goods,
  });

  final List<GoodEntity> allGoods;
  @override
  final List<GoodEntity> goods;

  FetchPreviewGoodsShipmentsLoaded copyWith({
    List<GoodEntity>? allGoods,
    List<GoodEntity>? goods,
  }) {
    return FetchPreviewGoodsShipmentsLoaded(
      allGoods: allGoods ?? this.allGoods,
      goods: goods ?? this.goods,
    );
  }

  @override
  List<Object?> get props => [allGoods, goods];

  @override
  GoodSearchableState copyWithGoods({required List<GoodEntity> goods}) {
    return copyWith(goods: goods);
  }
}

class FetchPreviewGoodsShipmentsError extends FetchPreviewGoodsShipments {
  FetchPreviewGoodsShipmentsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class CreateShipmentsLoading extends CreateShipments {}

class CreateShipmentsLoaded extends CreateShipments {
  CreateShipmentsLoaded({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class CreateShipmentsError extends CreateShipments {
  CreateShipmentsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class DeleteShipmentsLoading extends DeleteShipments {}

class DeleteShipmentsLoaded extends DeleteShipments {
  DeleteShipmentsLoaded({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class DeleteShipmentsError extends DeleteShipments {
  DeleteShipmentsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class FetchPickedGoodsLoading extends FetchPickedGoods {}

class FetchPickedGoodsLoaded extends FetchPickedGoods {
  FetchPickedGoodsLoaded({required this.pickedGoods});

  final List<PickedGoodEntity> pickedGoods;

  @override
  List<Object?> get props => [pickedGoods];
}

class FetchPickedGoodsError extends FetchPickedGoods {
  FetchPickedGoodsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class FetchLostGoodLoading extends FetchLostGood {}

class FetchLostGoodLoaded extends FetchLostGood {
  FetchLostGoodLoaded({required this.lostGood});

  final LostGoodEntity lostGood;

  @override
  List<Object?> get props => [lostGood];
}

class FetchLostGoodError extends FetchLostGood {
  FetchLostGoodError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class ResetUHFScan extends UHFAction {}

class OnUHFScan extends UHFAction {}

class QRCodeScan extends UHFAction {}
