class Failure {
  const Failure({
    required this.message,
    this.statusCode = 500,
  });

  final String message;
  final int statusCode;
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.statusCode,
  });
}
