import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/batch_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchDeliveryShipmentsUseCase
    implements UseCase<List<BatchEntity>, FetchDeliveryShipmentsUseCaseParams> {
  const FetchDeliveryShipmentsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchDeliveryShipmentsUseCaseParams params) async {
    return await inventoryRepositories.fetchDeliveryShipments(params: params);
  }
}

class FetchDeliveryShipmentsUseCaseParams {
  const FetchDeliveryShipmentsUseCaseParams({
    this.page,
    this.perPage,
    this.search,
  });

  final int? page;
  final int? perPage;
  final String? search;
}
