import 'package:dio/dio.dart';

import '../../features/auth/data/data_sources/auth_local_data_sources.dart';
import '../../service_locator.dart';

class CustomInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await getIt.get<AuthLocalDataSources>().getAccessToken();

    if (!options.path.endsWith('/login')) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
