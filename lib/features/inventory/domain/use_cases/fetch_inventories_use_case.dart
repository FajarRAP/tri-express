import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/lost_good_entity.dart';
import '../repositories/inventory_repository.dart';

class FetchInventoriesUseCase
    implements UseCase<List<LostGoodEntity>, FetchInventoriesUseCaseParams> {
  const FetchInventoriesUseCase({required this.inventoryRepository});

  final InventoryRepository inventoryRepository;

  @override
  Future<Either<Failure, List<LostGoodEntity>>> call(
      FetchInventoriesUseCaseParams params) async {
    return await inventoryRepository.fetchInventories(params);
  }
}

class FetchInventoriesUseCaseParams {
  const FetchInventoriesUseCaseParams({
    this.page,
    this.perPage,
    this.search,
  });

  final int? page;
  final int? perPage;
  final String? search;
}
