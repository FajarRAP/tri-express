import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../entities/batch_entity.dart';
import '../entities/good_entity.dart';
import '../use_cases/create_prepare_shipments_use_case.dart';
import '../use_cases/create_receive_shipments_use_case.dart';
import '../use_cases/fetch_delivery_shipments_use_case.dart';
import '../use_cases/fetch_inventories_use_case.dart';
import '../use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../use_cases/fetch_prepare_shipments_use_case.dart';
import '../use_cases/fetch_preview_delivery_shipments_use_case.dart';
import '../use_cases/fetch_preview_receive_shipments_use_case.dart';
import '../use_cases/fetch_receive_shipments_use_case.dart';

abstract class InventoryRepositories {
  Future<Either<Failure, String>> createPrepareShipments(
      {required CreatePrepareShipmentsUseCaseParams params});
  Future<Either<Failure, String>> createReceiveShipments(
      {required CreateReceiveShipmentsUseCaseParams params});
  Future<Either<Failure, String>> deletePreparedShipments(
      {required String shipmentId});
  Future<Either<Failure, List<BatchEntity>>> fetchDeliveryShipments(
      {required FetchDeliveryShipmentsUseCaseParams params});
  Future<Either<Failure, List<BatchEntity>>> fetchInventories(
      {required FetchInventoriesUseCaseParams params});
  Future<Either<Failure, int>> fetchInventoriesCount();
  Future<Either<Failure, List<BatchEntity>>> fetchOnTheWayShipments(
      {required FetchOnTheWayShipmentsUseCaseParams params});
  Future<Either<Failure, List<BatchEntity>>> fetchPrepareShipments(
      {required FetchPrepareShipmentsUseCaseParams params});
  Future<Either<Failure, List<BatchEntity>>> fetchPreviewDeliveryShipments(
      {required FetchPreviewDeliveryShipmentsUseCaseParams params});
  Future<Either<Failure, List<GoodEntity>>> fetchPreviewPrepareShipments(
      {required List<String> uniqueCodes});
  Future<Either<Failure, List<BatchEntity>>> fetchPreviewReceiveShipments(
      {required FetchPreviewReceiveShipmentsUseCaseParams params});
  Future<Either<Failure, List<BatchEntity>>> fetchReceiveShipments(
      {required FetchReceiveShipmentsUseCaseParams params});
}
