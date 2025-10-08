import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';
import '../use_cases/login_use_case.dart';

abstract interface class AuthRepositories {
  Future<Either<Failure, UserEntity>> fetchCurrentUser();
  Future<Either<Failure, String?>> getAccessToken();
  Future<Either<Failure, UserEntity>> login(LoginUseCaseParams params);
  Future<Either<Failure, String>> logout();
}
