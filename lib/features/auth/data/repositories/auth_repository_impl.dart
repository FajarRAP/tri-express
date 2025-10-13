import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/cache_exception.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/update_user_use_case.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.authLocalDataSource,
    required this.authRemoteDataSource,
  });

  final AuthLocalDataSource authLocalDataSource;
  final AuthRemoteDataSource authRemoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> fetchCurrentUser() async {
    try {
      final result = await authRemoteDataSource.fetchCurrentUser();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (e) {
      return Left(Failure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    try {
      final result = await authLocalDataSource.getAccessToken();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (e) {
      return Left(Failure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginUseCaseParams params) async {
    try {
      final result = await authRemoteDataSource.login(params);
      await authLocalDataSource.cacheToken(
        result.accessToken,
        result.refreshToken,
      );

      return Right(result.user);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (e) {
      return Left(Failure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      final result = await authRemoteDataSource.logout();
      await authLocalDataSource.clearToken();

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (e) {
      return Left(Failure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> updateUser(
      UpdateUserUseCaseParams params) async {
    try {
      final result = await authRemoteDataSource.updateUser(params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on CacheException catch (ce) {
      return Left(CacheFailure(
        message: ce.message,
        statusCode: ce.statusCode,
      ));
    } on InternalException catch (e) {
      return Left(Failure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    }
  }
}
