import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/inventory_repositories.dart';

class FetchShipmentReceiptNumbersUseCase
    implements UseCase<List<String>, NoParams> {
  FetchShipmentReceiptNumbersUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await inventoryRepositories.fetchShipmentReceiptNumbers();
  }
}
