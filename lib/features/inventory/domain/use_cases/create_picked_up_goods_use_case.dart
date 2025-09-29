import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/inventory_repositories.dart';

class CreatePickedUpGoodsUseCase
    implements UseCase<String, CreatePickedUpGoodsUseCaseParams> {
  const CreatePickedUpGoodsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, String>> call(
      CreatePickedUpGoodsUseCaseParams params) async {
    return await inventoryRepositories.createPickedUpGoods(params);
  }
}

class CreatePickedUpGoodsUseCaseParams {
  const CreatePickedUpGoodsUseCaseParams({
    required this.receiptNumbers,
    required this.uniqueCodes,
    required this.note,
    required this.imagePath,
    required this.pickedUpAt,
  });

  final List<String> receiptNumbers;
  final List<String> uniqueCodes;
  final String note;
  final String imagePath;
  final DateTime pickedUpAt;
}
