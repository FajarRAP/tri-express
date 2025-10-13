import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/timeline_summary_entity.dart';
import '../repositories/inventory_repository.dart';

class FetchGoodTimelineUseCase
    implements UseCase<TimelineSummaryEntity, String> {
  const FetchGoodTimelineUseCase({required this.inventoryRepository});

  final InventoryRepository inventoryRepository;

  @override
  Future<Either<Failure, TimelineSummaryEntity>> call(String params) async {
    return await inventoryRepository.fetchGoodTimeline(params);
  }
}
