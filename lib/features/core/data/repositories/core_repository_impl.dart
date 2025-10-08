import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/cache_exception.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/dropdown_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/core_repository.dart';
import '../data_sources/core_local_data_source.dart';
import '../data_sources/core_remote_data_source.dart';

class CoreRepositoryImpl implements CoreRepository {
  const CoreRepositoryImpl({
    required this.coreLocalDataSource,
    required this.coreRemoteDataSource,
  });

  final CoreLocalDataSource coreLocalDataSource;
  final CoreRemoteDataSource coreRemoteDataSource;

  @override
  Future<Either<Failure, void>> completeOnboarding() async {
    try {
      await coreLocalDataSource.completeOnboarding();

      return const Right(null);
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<String>>> fetchBanners() async {
    try {
      final result = await coreRemoteDataSource.fetchBanners();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchDriverDropdown() async {
    try {
      final result = await coreRemoteDataSource.fetchDriverDropdown();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications() async {
    try {
      final result = await coreRemoteDataSource.fetchNotifications();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<int>>> fetchSummary() async {
    try {
      final result = await coreRemoteDataSource.fetchSummary();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>>
      fetchTransportModeDropdown() async {
    try {
      final result = await coreRemoteDataSource.fetchTransportModeDropdown();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchWarehouseDropdown() async {
    try {
      final result = await coreRemoteDataSource.fetchWarehouseDropdown();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String?>> getOnboardingStatus() async {
    try {
      final result = await coreLocalDataSource.getOnboardingStatus();

      return Right(result);
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> readAllNotifications() async {
    try {
      final result = await coreRemoteDataSource.readAllNotifications();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> readNotification(
      String notificationId) async {
    try {
      final result =
          await coreRemoteDataSource.readNotification(notificationId);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }
}
