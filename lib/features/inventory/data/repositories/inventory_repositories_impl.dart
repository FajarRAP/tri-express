import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/entities/picked_good_entity.dart';
import '../../domain/repositories/inventory_repositories.dart';
import '../../domain/use_cases/create_delivery_shipments_use_case.dart';
import '../../domain/use_cases/create_picked_up_goods_use_case.dart';
import '../../domain/use_cases/create_prepare_shipments_use_case.dart';
import '../../domain/use_cases/create_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_inventories_use_case.dart';
import '../../domain/use_cases/fetch_picked_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_preview_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../../domain/use_cases/fetch_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';
import '../data_sources/inventory_remote_data_sources.dart';

class InventoryRepositoriesImpl extends InventoryRepositories {
  InventoryRepositoriesImpl({required this.inventoryRemoteDataSources});

  final InventoryRemoteDataSources inventoryRemoteDataSources;

  @override
  Future<Either<Failure, String>> createDeliveryShipments(
      CreateDeliveryShipmentsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.createDeliveryShipments(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> createPrepareShipments(
      CreatePrepareShipmentsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.createPrepareShipments(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> createReceiveShipments(
      CreateReceiveShipmentsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.createReceiveShipments(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> deletePreparedShipments(
      String shipmentId) async {
    try {
      final result =
          await inventoryRemoteDataSources.deletePreparedShipments(shipmentId);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchDeliveryShipments(
      FetchDeliveryShipmentsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchDeliveryShipments(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchInventories(
      FetchInventoriesUseCaseParams params) async {
    try {
      final result = await inventoryRemoteDataSources.fetchInventories(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, int>> fetchInventoriesCount() async {
    try {
      final result = await inventoryRemoteDataSources.fetchInventoriesCount();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchOnTheWayShipments(
      FetchOnTheWayShipmentsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchOnTheWayShipments(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<PickedGoodEntity>>> fetchPickedUpGoods(
      FetchPickedUpGoodsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchPickedUpGoods(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchPrepareShipments(
      FetchPrepareShipmentsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchPrepareShipments(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchPreviewDeliveryShipments(
      FetchPreviewDeliveryShipmentsUseCaseParams params) async {
    try {
      final result = await inventoryRemoteDataSources
          .fetchPreviewDeliveryShipments(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<GoodEntity>>> fetchPreviewPickUpGoods(
      List<String> uniqueCodes) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchPreviewPickUpGoods(uniqueCodes);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<GoodEntity>>> fetchPreviewPrepareShipments(
      List<String> uniqueCodes) async {
    try {
      final result = await inventoryRemoteDataSources
          .fetchPreviewPrepareShipments(uniqueCodes);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchPreviewReceiveShipments(
      FetchPreviewReceiveShipmentsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchPreviewReceiveShipments(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchReceiveShipments(
      FetchReceiveShipmentsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchReceiveShipments(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> createPickedUpGoods(
      CreatePickedUpGoodsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSources.createPickedUpGoods(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }
}
