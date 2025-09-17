import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/batch_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchOnTheWayShipmentsUseCase
    implements UseCase<List<BatchEntity>, FetchOnTheWayShipmentsUseCaseParams> {
  const FetchOnTheWayShipmentsUseCase(
      {required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchOnTheWayShipmentsUseCaseParams params) async {
    return await inventoryRepositories.fetchOnTheWayShipments(params: params);
  }
}

final class FetchOnTheWayShipmentsUseCaseParams {
  const FetchOnTheWayShipmentsUseCaseParams({
    this.page,
    this.perPage,
    this.search,
  });

  final int? page;
  final int? perPage;
  final String? search;
}
