import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/cache_exception.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/dropdown_entity.dart';
import '../../domain/repositories/core_repositories.dart';
import '../data_sources/core_local_data_sources.dart';
import '../data_sources/core_remote_data_sources.dart';

class CoreRepositoriesImpl extends CoreRepositories {
  CoreRepositoriesImpl({
    required this.coreLocalDataSources,
    required this.coreRemoteDataSources,
  });

  final CoreLocalDataSources coreLocalDataSources;
  final CoreRemoteDataSources coreRemoteDataSources;

  @override
  Future<Either<Failure, void>> completeOnboarding() async {
    try {
      await coreLocalDataSources.completeOnboarding();

      return const Right(null);
    } on CacheException catch (ce) {
      return Left(CacheFailure(message: ce.message, statusCode: ce.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<String>>> fetchBanners() async {
    try {
      final result = await coreRemoteDataSources.fetchBanners();

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
      final result = await coreRemoteDataSources.fetchDriverDropdown();

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
      final result = await coreRemoteDataSources.fetchSummary();

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
      final result = await coreRemoteDataSources.fetchTransportModeDropdown();

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
      final result = await coreRemoteDataSources.fetchWarehouseDropdown();

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
      final result = await coreLocalDataSources.getOnboardingStatus();

      return Right(result);
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    }
  }
}
