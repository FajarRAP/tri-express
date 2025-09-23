import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../core/domain/entities/dropdown_entity.dart';
import '../repositories/inventory_repositories.dart';

class CreatePrepareShipmentsUseCase
    implements UseCase<String, CreatePrepareShipmentsUseCaseParams> {
  const CreatePrepareShipmentsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;
  @override
  Future<Either<Failure, String>> call(
      CreatePrepareShipmentsUseCaseParams params) async {
    return await inventoryRepositories.createPrepareShipments(params: params);
  }
}

class CreatePrepareShipmentsUseCaseParams {
  const CreatePrepareShipmentsUseCaseParams({
    required this.shippedAt,
    required this.estimatedAt,
    required this.nextWarehouse,
    required this.transportMode,
    required this.batchName,
    required this.uniqueCodes,
  });

  final DateTime shippedAt;
  final DateTime estimatedAt;
  final DropdownEntity nextWarehouse;
  final DropdownEntity transportMode;
  final String batchName;
  final List<String> uniqueCodes;
}
