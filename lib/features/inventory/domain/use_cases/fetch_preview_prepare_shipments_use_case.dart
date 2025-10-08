import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/good_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchPreviewPrepareShipmentsUseCase
    implements UseCase<List<GoodEntity>, List<String>> {
  const FetchPreviewPrepareShipmentsUseCase(
      {required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, List<GoodEntity>>> call(List<String> params) async {
    return await inventoryRepositories.fetchPreviewPrepareShipments(params);
  }
}
