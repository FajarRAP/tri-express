import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/batch_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchReceiveGoodsUseCase
    implements UseCase<List<BatchEntity>, FetchReceiveGoodsUseCaseParams> {
  FetchReceiveGoodsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchReceiveGoodsUseCaseParams params) async {
    return await inventoryRepositories.fetchReceiveGoods(params: params);
  }
}

class FetchReceiveGoodsUseCaseParams {
  const FetchReceiveGoodsUseCaseParams({
    required this.page,
    this.search,
  });

  final int page;
  final String? search;
}
