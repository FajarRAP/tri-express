import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repositories.dart';

class LoginUseCase implements UseCase<UserEntity, LoginUseCaseParams> {
  const LoginUseCase({required this.authRepositories});

  final AuthRepositories authRepositories;

  @override
  Future<Either<Failure, UserEntity>> call(LoginUseCaseParams params) async {
    return await authRepositories.login(params);
  }
}

final class LoginUseCaseParams {
  const LoginUseCaseParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
