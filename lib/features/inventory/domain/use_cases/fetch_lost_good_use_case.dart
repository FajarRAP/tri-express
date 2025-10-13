import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/lost_good_entity.dart';
import '../repositories/inventory_repository.dart';

class FetchLostGoodUseCase implements UseCase<LostGoodEntity, String> {
  const FetchLostGoodUseCase({required this.inventoryRepository});

  final InventoryRepository inventoryRepository;

  @override
  Future<Either<Failure, LostGoodEntity>> call(String params) async {
    return await inventoryRepository.fetchLostGood(params);
  }
}
