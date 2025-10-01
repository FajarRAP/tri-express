import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/dropdown_entity.dart';
import '../repositories/core_repository.dart';

class FetchDriverDropdownUseCase
    implements UseCase<List<DropdownEntity>, NoParams> {
  const FetchDriverDropdownUseCase({required this.coreRepository});

  final CoreRepository coreRepository;

  @override
  Future<Either<Failure, List<DropdownEntity>>> call(NoParams params) async {
    return await coreRepository.fetchDriverDropdown();
  }
}
