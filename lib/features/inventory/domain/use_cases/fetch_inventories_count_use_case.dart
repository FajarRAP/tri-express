import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/inventory_repositories.dart';

class FetchInventoriesCountUseCase implements UseCase<int, NoParams> {
  const FetchInventoriesCountUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await inventoryRepositories.fetchInventoriesCount();
  }
}
