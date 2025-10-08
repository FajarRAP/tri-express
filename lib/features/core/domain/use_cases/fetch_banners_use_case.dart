import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/core_repository.dart';

class FetchBannersUseCase implements UseCase<List<String>, NoParams> {
  const FetchBannersUseCase({required this.coreRepository});

  final CoreRepository coreRepository;

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await coreRepository.fetchBanners();
  }
}
