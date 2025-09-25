import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../core/domain/entities/dropdown_entity.dart';
import '../repositories/inventory_repositories.dart';

class CreateDeliveryShipmentsUseCase
    implements UseCase<String, CreateDeliveryShipmentsUseCaseParams> {
  const CreateDeliveryShipmentsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, String>> call(
      CreateDeliveryShipmentsUseCaseParams params) async {
    return await inventoryRepositories.createDeliveryShipments(params);
  }
}

class CreateDeliveryShipmentsUseCaseParams {
  const CreateDeliveryShipmentsUseCaseParams({
    required this.nextWarehouse,
    required this.driver,
    required this.uniqueCodes,
    required this.shipmentIds,
    required this.deliveredAt,
  });

  final DropdownEntity nextWarehouse;
  final DropdownEntity driver;
  final List<String> uniqueCodes;
  final List<String> shipmentIds;
  final DateTime deliveredAt;
}
