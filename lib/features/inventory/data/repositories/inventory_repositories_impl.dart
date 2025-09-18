import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/repositories/inventory_repositories.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_inventories_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../../domain/use_cases/fetch_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';
import '../data_sources/inventory_remote_data_sources.dart';

class InventoryRepositoriesImpl extends InventoryRepositories {
  InventoryRepositoriesImpl({required this.inventoryRemoteDataSources});

  final InventoryRemoteDataSources inventoryRemoteDataSources;

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchDeliveryShipments(
      {required FetchDeliveryShipmentsUseCaseParams params}) async {
    try {
      final result = await inventoryRemoteDataSources.fetchDeliveryShipments(
          params: params);

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
      {required FetchInventoriesUseCaseParams params}) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchInventories(params: params);

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
      {required FetchOnTheWayShipmentsUseCaseParams params}) async {
    try {
      final result = await inventoryRemoteDataSources.fetchOnTheWayShipments(
          params: params);

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
      {required FetchPrepareShipmentsUseCaseParams params}) async {
    try {
      final result = await inventoryRemoteDataSources.fetchPrepareShipments(
          params: params);

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
      {required FetchReceiveShipmentsUseCaseParams params}) async {
    try {
      final result = await inventoryRemoteDataSources.fetchReceiveShipments(
          params: params);

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
