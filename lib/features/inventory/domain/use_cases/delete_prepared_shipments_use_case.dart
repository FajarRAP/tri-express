import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/inventory_repositories.dart';

class DeletePreparedShipmentsUseCase implements UseCase<String, String> {
  const DeletePreparedShipmentsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await inventoryRepositories.deletePreparedShipments(params);
  }
}
