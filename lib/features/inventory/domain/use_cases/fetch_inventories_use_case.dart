import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/batch_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchInventoriesUseCase
    implements UseCase<List<BatchEntity>, FetchInventoriesUseCaseParams> {
  const FetchInventoriesUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;
  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchInventoriesUseCaseParams params) async {
    return await inventoryRepositories.fetchInventories(params: params);
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
