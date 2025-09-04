import 'package:fpdart/fpdart.dart';
import 'package:tri_express/core/exceptions/internal_exception.dart';
import 'package:tri_express/core/exceptions/server_exception.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../data_sources/auth_remote_data_sources.dart';

class AuthRepositoriesImpl extends AuthRepositories {
  AuthRepositoriesImpl({required this.authRemoteDataSources});

  final AuthRemoteDataSources authRemoteDataSources;

  @override
  Future<Either<Failure, UserEntity>> fetchCurrentUser() async {
    try {
      final response = await authRemoteDataSources.fetchCurrentUser();

      return Right(response);
    } on ServerException catch (sf) {
      return Left(ServerFailure(
        message: sf.message,
        statusCode: sf.statusCode,
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
      final response = await authRemoteDataSources.login(params: params);

      return Right(response);
    } on ServerException catch (sf) {
      return Left(ServerFailure(
        message: sf.message,
        statusCode: sf.statusCode,
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
      final response = await authRemoteDataSources.logout();

      return Right(response);
    } on ServerException catch (sf) {
      return Left(ServerFailure(
        message: sf.message,
        statusCode: sf.statusCode,
      ));
    } on InternalException catch (e) {
      return Left(Failure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    }
  }
}
