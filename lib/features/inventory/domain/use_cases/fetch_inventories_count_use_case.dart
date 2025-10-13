import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/inventory_repository.dart';

class FetchInventoriesCountUseCase implements UseCase<int, NoParams> {
  const FetchInventoriesCountUseCase({required this.inventoryRepository});

  final InventoryRepository inventoryRepository;

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await inventoryRepository.fetchInventoriesCount();
  }
}
