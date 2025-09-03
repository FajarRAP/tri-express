import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repositories.dart';

class FetchCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  const FetchCurrentUserUseCase({required this.authRepositories});

  final AuthRepositories authRepositories;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await authRepositories.fetchCurrentUser();
  }
}
