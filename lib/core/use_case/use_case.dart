import 'package:fpdart/fpdart.dart';

import '../failure/failure.dart';

abstract interface class UseCase<Return, Params> {
  Future<Either<Failure, Return>> call(Params params);
}

class NoParams {}
