import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/core_repositories.dart';

class GetOnboardingStatusUseCase implements UseCase<String?, NoParams> {
  const GetOnboardingStatusUseCase({required this.coreRepositories});

  final CoreRepositories coreRepositories;

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await coreRepositories.getOnboardingStatus();
  }
}
