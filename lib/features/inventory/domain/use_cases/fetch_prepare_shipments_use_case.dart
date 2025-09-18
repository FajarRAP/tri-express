import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/batch_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchPrepareShipmentsUseCase
    implements UseCase<List<BatchEntity>, FetchPrepareShipmentsUseCaseParams> {
  const FetchPrepareShipmentsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;
  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchPrepareShipmentsUseCaseParams params) async {
    return await inventoryRepositories.fetchPrepareShipments(params: params);
  }
}

final class FetchPrepareShipmentsUseCaseParams {
  const FetchPrepareShipmentsUseCaseParams({
    this.page,
    this.perPage,
    this.search,
  });

  final int? page;
  final int? perPage;
  final String? search;
}
