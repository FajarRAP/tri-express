import 'package:dio/dio.dart';

import '../../features/auth/domain/use_cases/get_access_token_use_case.dart';
import '../use_case/use_case.dart';

class CustomInterceptor implements Interceptor {
  CustomInterceptor({required GetAccessTokenUseCase getAccessTokenUseCase})
      : _getAccessTokenUseCase = getAccessTokenUseCase;

  final GetAccessTokenUseCase _getAccessTokenUseCase;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final result = await _getAccessTokenUseCase(NoParams());

    result.fold(
      (_) => _,
      (accessToken) {
        if (!options.path.endsWith('/login')) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
      },
    );

    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
