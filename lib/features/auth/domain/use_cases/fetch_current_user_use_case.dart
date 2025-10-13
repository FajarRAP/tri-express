import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class FetchCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  const FetchCurrentUserUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await authRepository.fetchCurrentUser();
  }
}
