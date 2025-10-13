import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../core/domain/entities/dropdown_entity.dart';
import '../entities/batch_entity.dart';
import '../repositories/inventory_repository.dart';

class FetchPreviewDeliveryShipmentsUseCase
    implements
        UseCase<List<BatchEntity>, FetchPreviewDeliveryShipmentsUseCaseParams> {
  const FetchPreviewDeliveryShipmentsUseCase(
      {required this.inventoryRepository});

  final InventoryRepository inventoryRepository;

  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchPreviewDeliveryShipmentsUseCaseParams params) async {
    return await inventoryRepository.fetchPreviewDeliveryShipments(params);
  }
}

class FetchPreviewDeliveryShipmentsUseCaseParams {
  const FetchPreviewDeliveryShipmentsUseCaseParams({
    required this.nextWarehouse,
    required this.uniqueCodes,
  });

  final DropdownEntity nextWarehouse;
  final List<String> uniqueCodes;
}
