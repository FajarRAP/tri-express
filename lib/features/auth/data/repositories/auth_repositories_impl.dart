import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/cache_exception.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../data_sources/auth_local_data_sources.dart';
import '../data_sources/auth_remote_data_sources.dart';

class AuthRepositoriesImpl extends AuthRepositories {
  AuthRepositoriesImpl({
    required this.authLocalDataSources,
    required this.authRemoteDataSources,
  });

  final AuthLocalDataSources authLocalDataSources;
  final AuthRemoteDataSources authRemoteDataSources;

  @override
  Future<Either<Failure, UserEntity>> fetchCurrentUser() async {
    try {
      final result = await authRemoteDataSources.fetchCurrentUser();

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
      final result = await authLocalDataSources.getAccessToken();

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
  Future<Either<Failure, UserEntity>> login(
      {required LoginParams params}) async {
    try {
      final result = await authRemoteDataSources.login(params: params);
      await authLocalDataSources.cacheToken(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
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
      final result = await authRemoteDataSources.logout();
      await authLocalDataSources.clearToken();

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
