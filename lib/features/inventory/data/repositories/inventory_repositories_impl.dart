import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/repositories/inventory_repositories.dart';
import '../../domain/use_cases/fetch_delivery_goods_use_case.dart';
import '../../domain/use_cases/fetch_receive_goods_use_case.dart';
import '../data_sources/inventory_remote_data_sources.dart';

class InventoryRepositoriesImpl extends InventoryRepositories {
  InventoryRepositoriesImpl({required this.inventoryRemoteDataSources});

  final InventoryRemoteDataSources inventoryRemoteDataSources;

  @override
  Future<Either<Failure, Object>> fetchDeliveryGood({required String id}) {
    // TODO: implement fetchDeliveryGood
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchDeliveryGoods(
      {required FetchDeliveryGoodsUseCaseParams params}) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchDeliveryGoods(params: params);

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
  Future<Either<Failure, Object>> fetchInvoice({required String id}) {
    // TODO: implement fetchInvoice
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List>> fetchInvoices() {
    // TODO: implement fetchInvoices
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Object>> fetchOnTheWayGood({required String id}) {
    // TODO: implement fetchOnTheWayGood
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchOnTheWayGoods() {
    // TODO: implement fetchOnTheWayGoods
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Object>> fetchPrepareGood({required String id}) {
    // TODO: implement fetchPrepareGood
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchPrepareGoods() {
    // TODO: implement fetchPrepareGoods
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Object>> fetchReceiveGood({required String id}) {
    // TODO: implement fetchReceiveGood
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> fetchReceiveGoods(
      {required FetchReceiveGoodsUseCaseParams params}) async {
    try {
      final result =
          await inventoryRemoteDataSources.fetchReceiveGoods(params: params);

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
  Future<Either<Failure, List<String>>> fetchShipmentReceiptNumbers() {
    // TODO: implement fetchReceiptNumbers
    throw UnimplementedError();
  }
}
