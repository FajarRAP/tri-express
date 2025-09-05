import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';

abstract class CoreRepositories {
  Future<Either<Failure, void>> completeOnboarding();
  Future<Either<Failure, List<String>>> fetchBanners();
}
