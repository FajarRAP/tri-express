import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/batch_entity.dart';
import '../repositories/inventory_repositories.dart';

class FetchReceiveShipmentsUseCase
    implements UseCase<List<BatchEntity>, FetchReceiveShipmentsUseCaseParams> {
  FetchReceiveShipmentsUseCase({required this.inventoryRepositories});

  final InventoryRepositories inventoryRepositories;

  @override
  Future<Either<Failure, List<BatchEntity>>> call(
      FetchReceiveShipmentsUseCaseParams params) async {
    return await inventoryRepositories.fetchReceiveShipments(params: params);
  }
}

class FetchReceiveShipmentsUseCaseParams {
  const FetchReceiveShipmentsUseCaseParams({
    this.page,
    this.perPage,
    this.search,
  });

  final int? page;
  final int? perPage;
  final String? search;
}
