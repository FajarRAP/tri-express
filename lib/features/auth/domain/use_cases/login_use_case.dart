import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginUseCaseParams> {
  const LoginUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginUseCaseParams params) async {
    return await authRepository.login(params);
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
