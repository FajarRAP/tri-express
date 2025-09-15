import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/dropdown_entity.dart';
import '../repositories/core_repositories.dart';

class FetchTransportModeDropdownUseCase
    implements UseCase<List<DropdownEntity>, NoParams> {
  const FetchTransportModeDropdownUseCase({required this.coreRepositories});

  final CoreRepositories coreRepositories;

  @override
  Future<Either<Failure, List<DropdownEntity>>> call(NoParams params) async {
    return await coreRepositories.fetchTransportModeDropdown();
  }
}
