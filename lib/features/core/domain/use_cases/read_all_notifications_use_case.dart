import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/core_repository.dart';

class ReadAllNotificationsUseCase implements UseCase<String, NoParams> {
  const ReadAllNotificationsUseCase({required this.coreRepository});

  final CoreRepository coreRepository;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await coreRepository.readAllNotifications();
  }
}
