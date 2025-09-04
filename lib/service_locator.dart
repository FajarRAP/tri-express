import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/utils/dio_interceptor.dart';
import 'features/auth/data/data_sources/auth_local_data_sources.dart';
import 'features/auth/data/data_sources/auth_remote_data_sources.dart';
import 'features/auth/data/repositories/auth_repositories_impl.dart';
import 'features/auth/domain/repositories/auth_repositories.dart';
import 'features/auth/domain/use_cases/fetch_current_user_use_case.dart';
import 'features/auth/domain/use_cases/login_use_case.dart';
import 'features/auth/domain/use_cases/logout_use_case.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment('API_URL'),
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    )..interceptors.add(CustomInterceptor()),
  );

  getIt
    ..registerLazySingleton<AuthRemoteDataSources>(
        () => AuthRemoteDataSourcesImpl(dio: getIt.get()))
    ..registerLazySingleton<AuthLocalDataSources>(
        () => AuthLocalDataSourcesImpl(storage: getIt.get()))
    ..registerLazySingleton<AuthRepositories>(() => AuthRepositoriesImpl(
        authLocalDataSources: getIt.get(), authRemoteDataSources: getIt.get()))
    ..registerLazySingleton<AuthCubit>(() => AuthCubit(
        fetchCurrentUserUseCase:
            FetchCurrentUserUseCase(authRepositories: getIt.get()),
        loginUseCase: LoginUseCase(authRepositories: getIt.get()),
        logoutUseCase: LogoutUseCase(authRepositories: getIt.get())));
}
