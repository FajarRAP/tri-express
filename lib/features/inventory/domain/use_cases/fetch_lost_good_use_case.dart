import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/lost_good_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchLostGoodUseCase implements UseCase<LostGoodEntity, String> {
  const FetchLostGoodUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, LostGoodEntity>> call(String params) async {
    return await inventoryRepositories.fetchLostGood(params);
  }
}
