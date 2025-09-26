import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/good_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchPreviewPickUpGoodsUseCase
    implements UseCase<List<GoodEntity>, List<String>> {
  const FetchPreviewPickUpGoodsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, List<GoodEntity>>> call(List<String> params) async {
    return await inventoryRepositories.fetchPreviewPickUpGoods(params);
  }
}
