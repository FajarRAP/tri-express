import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../core/domain/entities/dropdown_entity.dart';
import '../entities/batch_entity.dart';
import '../repositories/inventory_repository.dart';

class FetchPreviewReceiveShipmentsUseCase
    implements
        UseCase<List<BatchEntity>, FetchPreviewReceiveShipmentsUseCaseParams> {
  const FetchPreviewReceiveShipmentsUseCase(
      {required this.inventoryRepository});

  final InventoryRepository inventoryRepository;

  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchPreviewReceiveShipmentsUseCaseParams params) async {
    return await inventoryRepository.fetchPreviewReceiveShipments(params);
  }
}

class FetchPreviewReceiveShipmentsUseCaseParams {
  const FetchPreviewReceiveShipmentsUseCaseParams({
    required this.origin,
    required this.uniqueCodes,
  });

  final DropdownEntity origin;
  final List<String> uniqueCodes;
}
