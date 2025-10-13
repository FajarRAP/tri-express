import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

class UpdateUserUseCase implements UseCase<String, UpdateUserUseCaseParams> {
  const UpdateUserUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String>> call(UpdateUserUseCaseParams params) async {
    return await authRepository.updateUser(params);
  }
}

class UpdateUserUseCaseParams {
  const UpdateUserUseCaseParams({
    required this.name,
    required this.email,
    this.password,
    this.avatarPath,
    this.phoneNumber,
  });

  final String name;
  final String email;
  final String? password;
  final String? avatarPath;
  final String? phoneNumber;
}
