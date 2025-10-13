import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/entities/lost_good_entity.dart';
import '../../domain/entities/picked_good_entity.dart';
import '../../domain/entities/timeline_summary_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
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

class InventoryRepositoryImpl implements InventoryRepository {
  const InventoryRepositoryImpl({required this.inventoryRemoteDataSource});

  final InventoryRemoteDataSource inventoryRemoteDataSource;

  @override
  Future<Either<Failure, String>> createDeliveryShipments(
      CreateDeliveryShipmentsUseCaseParams params) async {
    try {
      final result =
          await inventoryRemoteDataSource.createDeliveryShipments(params);

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
          await inventoryRemoteDataSource.createPickedUpGoods(params);

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
          await inventoryRemoteDataSource.createPrepareShipments(params);

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
          await inventoryRemoteDataSource.createReceiveShipments(params);

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
          await inventoryRemoteDataSource.deletePreparedShipments(shipmentId);

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
          await inventoryRemoteDataSource.fetchDeliveryShipments(params);

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
  Future<Either<Failure, TimelineSummaryEntity>> fetchGoodTimeline(
      String receiptNumber) async {
    try {
      final result =
          await inventoryRemoteDataSource.fetchGoodTimeline(receiptNumber);

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
      final result = await inventoryRemoteDataSource.fetchInventories(params);

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
      final result = await inventoryRemoteDataSource.fetchInventoriesCount();

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
  Future<Either<Failure, LostGoodEntity>> fetchLostGood(
      String uniqueCode) async {
    try {
      final result = await inventoryRemoteDataSource.fetchLostGood(uniqueCode);

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
          await inventoryRemoteDataSource.fetchOnTheWayShipments(params);

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
      final result = await inventoryRemoteDataSource.fetchPickedUpGoods(params);

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
          await inventoryRemoteDataSource.fetchPrepareShipments(params);

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
      final result =
          await inventoryRemoteDataSource.fetchPreviewDeliveryShipments(params);

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
          await inventoryRemoteDataSource.fetchPreviewPickUpGoods(uniqueCodes);

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
      final result = await inventoryRemoteDataSource
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
          await inventoryRemoteDataSource.fetchPreviewReceiveShipments(params);

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
          await inventoryRemoteDataSource.fetchReceiveShipments(params);

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
