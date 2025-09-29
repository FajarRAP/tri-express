import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../entities/batch_entity.dart';
import '../entities/good_entity.dart';
import '../entities/picked_good_entity.dart';
import '../use_cases/create_delivery_shipments_use_case.dart';
import '../use_cases/create_picked_up_goods_use_case.dart';
import '../use_cases/create_prepare_shipments_use_case.dart';
import '../use_cases/create_receive_shipments_use_case.dart';
import '../use_cases/fetch_delivery_shipments_use_case.dart';
import '../use_cases/fetch_inventories_use_case.dart';
import '../use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../use_cases/fetch_picked_up_goods_use_case.dart';
import '../use_cases/fetch_prepare_shipments_use_case.dart';
import '../use_cases/fetch_preview_delivery_shipments_use_case.dart';
import '../use_cases/fetch_preview_receive_shipments_use_case.dart';
import '../use_cases/fetch_receive_shipments_use_case.dart';

abstract class InventoryRepositories {
  Future<Either<Failure, String>> createDeliveryShipments(
      CreateDeliveryShipmentsUseCaseParams params);
  Future<Either<Failure, String>> createPrepareShipments(
      CreatePrepareShipmentsUseCaseParams params);
  Future<Either<Failure, String>> createReceiveShipments(
      CreateReceiveShipmentsUseCaseParams params);
  Future<Either<Failure, String>> createPickedUpGoods(
      CreatePickedUpGoodsUseCaseParams params);
  Future<Either<Failure, String>> deletePreparedShipments(String shipmentId);
  Future<Either<Failure, List<BatchEntity>>> fetchDeliveryShipments(
      FetchDeliveryShipmentsUseCaseParams params);
  Future<Either<Failure, List<BatchEntity>>> fetchInventories(
      FetchInventoriesUseCaseParams params);
  Future<Either<Failure, int>> fetchInventoriesCount();
  Future<Either<Failure, List<BatchEntity>>> fetchOnTheWayShipments(
      FetchOnTheWayShipmentsUseCaseParams params);
  Future<Either<Failure, List<PickedGoodEntity>>> fetchPickedUpGoods(
      FetchPickedUpGoodsUseCaseParams params);
  Future<Either<Failure, List<BatchEntity>>> fetchPrepareShipments(
      FetchPrepareShipmentsUseCaseParams params);
  Future<Either<Failure, List<BatchEntity>>> fetchPreviewDeliveryShipments(
      FetchPreviewDeliveryShipmentsUseCaseParams params);
  Future<Either<Failure, List<GoodEntity>>> fetchPreviewPickUpGoods(
      List<String> uniqueCodes);
  Future<Either<Failure, List<GoodEntity>>> fetchPreviewPrepareShipments(
      List<String> uniqueCodes);
  Future<Either<Failure, List<BatchEntity>>> fetchPreviewReceiveShipments(
      FetchPreviewReceiveShipmentsUseCaseParams params);
  Future<Either<Failure, List<BatchEntity>>> fetchReceiveShipments(
      FetchReceiveShipmentsUseCaseParams params);
}
