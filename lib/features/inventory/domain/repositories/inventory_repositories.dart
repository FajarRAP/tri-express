import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../entities/batch_entity.dart';
import '../use_cases/fetch_delivery_goods_use_case.dart';

abstract class InventoryRepositories {
  Future<Either<Failure, List<BatchEntity>>> fetchPrepareGoods();
  Future<Either<Failure, Object>> fetchPrepareGood({required String id});
  Future<Either<Failure, List>> fetchInvoices();
  Future<Either<Failure, Object>> fetchInvoice({required String id});
  Future<Either<Failure, List<BatchEntity>>> fetchDeliveryGoods(
      {required FetchDeliveryGoodsUseCaseParams params});
  Future<Either<Failure, Object>> fetchDeliveryGood({required String id});
  Future<Either<Failure, List<BatchEntity>>> fetchOnTheWayGoods();
  Future<Either<Failure, Object>> fetchOnTheWayGood({required String id});
  Future<Either<Failure, List<BatchEntity>>> fetchReceiveGoods();
  Future<Either<Failure, Object>> fetchReceiveGood({required String id});
  Future<Either<Failure, List<String>>> fetchShipmentReceiptNumbers();
}
