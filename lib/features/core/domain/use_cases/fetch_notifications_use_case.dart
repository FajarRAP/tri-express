import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/notification_entity.dart';
import '../repositories/core_repository.dart';

class FetchNotificationsUseCase
    implements UseCase<List<NotificationEntity>, NoParams> {
  const FetchNotificationsUseCase({required this.coreRepository});

  final CoreRepository coreRepository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
      NoParams params) async {
    return await coreRepository.fetchNotifications();
  }
}
