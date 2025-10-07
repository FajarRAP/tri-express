import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/core_repository.dart';

class ReadNotificationUseCase implements UseCase<String, String> {
  const ReadNotificationUseCase({required this.coreRepository});

  final CoreRepository coreRepository;

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await coreRepository.readNotification(params);
  }
}
