import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/core_repositories.dart';

class FetchSummaryUseCase implements UseCase<List<int>, NoParams> {
  const FetchSummaryUseCase({required this.coreRepositories});

  final CoreRepositories coreRepositories;

  @override
  Future<Either<Failure, List<int>>> call(NoParams params) async {
    return await coreRepositories.fetchSummary();
  }
}
