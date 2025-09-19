import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/batch_entity.dart';
import '../entities/warehouse_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchPreviewReceiveShipmentsUseCase
    implements
        UseCase<List<BatchEntity>, FetchPreviewReceiveShipmentsUseCaseParams> {
  const FetchPreviewReceiveShipmentsUseCase(
      {required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchPreviewReceiveShipmentsUseCaseParams params) async {
    return await inventoryRepositories.fetchPreviewReceiveShipments(
        params: params);
  }
}

class FetchPreviewReceiveShipmentsUseCaseParams {
  const FetchPreviewReceiveShipmentsUseCaseParams({
    this.origin,
    required this.uniqueCodes,
  });

  final WarehouseEntity? origin;
  final List<String> uniqueCodes;
}
