import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/good_entity.dart';
import '../repositories/inventory_repository.dart';

class FetchPreviewPickUpGoodsUseCase
    implements UseCase<List<GoodEntity>, List<String>> {
  const FetchPreviewPickUpGoodsUseCase({required this.inventoryRepository});

  final InventoryRepository inventoryRepository;

  @override
  Future<Either<Failure, List<GoodEntity>>> call(List<String> params) async {
    return await inventoryRepository.fetchPreviewPickUpGoods(params);
  }
}
