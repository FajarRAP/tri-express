import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/inventory_repository.dart';

class CreateReceiveShipmentsUseCase
    implements UseCase<String, CreateReceiveShipmentsUseCaseParams> {
  const CreateReceiveShipmentsUseCase({required this.inventoryRepository});

  final InventoryRepository inventoryRepository;

  @override
  Future<Either<Failure, String>> call(
      CreateReceiveShipmentsUseCaseParams params) async {
    return await inventoryRepository.createReceiveShipments(params);
  }
}

class CreateReceiveShipmentsUseCaseParams {
  const CreateReceiveShipmentsUseCaseParams({
    required this.receivedAt,
    required this.uniqueCodes,
  });

  final DateTime receivedAt;
  final List<String> uniqueCodes;
}
