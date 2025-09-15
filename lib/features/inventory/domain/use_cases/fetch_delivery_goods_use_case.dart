import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/batch_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchDeliveryGoodsUseCase
    implements UseCase<List<BatchEntity>, FetchDeliveryGoodsUseCaseParams> {
  const FetchDeliveryGoodsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchDeliveryGoodsUseCaseParams params) async {
    return await inventoryRepositories.fetchDeliveryGoods(params: params);
  }
}

class FetchDeliveryGoodsUseCaseParams {
  final int? currentPage;
  final int? perPage;

  const FetchDeliveryGoodsUseCaseParams({
    this.currentPage,
    this.perPage,
  });
}
