import 'package:fpdart/fpdart.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repositories.dart';

class LogoutUseCase implements UseCase<String, NoParams> {
  const LogoutUseCase({required this.authRepositories});

  final AuthRepositories authRepositories;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await authRepositories.logout();
  }
}
