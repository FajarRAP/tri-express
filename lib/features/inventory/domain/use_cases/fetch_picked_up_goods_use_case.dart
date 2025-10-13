import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/picked_good_entity.dart';
import '../repositories/inventory_repository.dart';

class FetchPickedUpGoodsUseCase
    implements
        UseCase<List<PickedGoodEntity>, FetchPickedUpGoodsUseCaseParams> {
  const FetchPickedUpGoodsUseCase({required this.inventoryRepository});

  final InventoryRepository inventoryRepository;

  @override
  Future<Either<Failure, List<PickedGoodEntity>>> call(
      FetchPickedUpGoodsUseCaseParams params) async {
    return await inventoryRepository.fetchPickedUpGoods(params);
  }
}

class FetchPickedUpGoodsUseCaseParams {
  const FetchPickedUpGoodsUseCaseParams({
    this.page,
    this.perPage,
    this.search,
  });

  final int? page;
  final int? perPage;
  final String? search;
}
