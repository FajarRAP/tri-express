import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../entities/batch_entity.dart';
import '../use_cases/fetch_delivery_shipments_use_case.dart';
import '../use_cases/fetch_receive_shipments_use_case.dart';

abstract class InventoryRepositories {
  Future<Either<Failure, List<BatchEntity>>> fetchDeliveryShipments(
      {required FetchDeliveryShipmentsUseCaseParams params});
  Future<Either<Failure, List<BatchEntity>>> fetchInventories();
  Future<Either<Failure, List<BatchEntity>>> fetchOnTheWayShipments();
  Future<Either<Failure, List<BatchEntity>>> fetchPrepareShipmentss();
  Future<Either<Failure, List<BatchEntity>>> fetchReceiveShipments(
      {required FetchReceiveShipmentsUseCaseParams params});
}
