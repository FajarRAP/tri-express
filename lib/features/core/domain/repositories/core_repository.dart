import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../entities/dropdown_entity.dart';
import '../entities/notification_entity.dart';

abstract interface class CoreRepository {
  Future<Either<Failure, void>> completeOnboarding();
  Future<Either<Failure, List<String>>> fetchBanners();
  Future<Either<Failure, List<DropdownEntity>>> fetchDriverDropdown();
  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications();
  Future<Either<Failure, List<int>>> fetchSummary();
  Future<Either<Failure, List<DropdownEntity>>> fetchTransportModeDropdown();
  Future<Either<Failure, List<DropdownEntity>>> fetchWarehouseDropdown();
  Future<Either<Failure, String?>> getOnboardingStatus();
  Future<Either<Failure, String>> readAllNotifications();
  Future<Either<Failure, String>> readNotification(String notificationId);
}
