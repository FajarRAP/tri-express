import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/core_repositories.dart';

class CompleteOnboardingUseCase implements UseCase<void, NoParams> {
  const CompleteOnboardingUseCase({required this.coreRepositories});
  final CoreRepositories coreRepositories;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await coreRepositories.completeOnboarding();
  }
}
