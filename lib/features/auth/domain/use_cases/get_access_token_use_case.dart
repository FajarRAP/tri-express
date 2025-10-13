import 'package:fpdart/src/either.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

class GetAccessTokenUseCase implements UseCase<String?, NoParams> {
  const GetAccessTokenUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await authRepository.getAccessToken();
  }
}
