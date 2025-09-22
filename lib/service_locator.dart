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
import 'features/core/data/data_sources/core_local_data_sources.dart';
import 'features/core/data/data_sources/core_remote_data_sources.dart';
import 'features/core/data/repositories/core_repositories_impl.dart';
import 'features/core/domain/repositories/core_repositories.dart';
import 'features/core/domain/use_cases/complete_onboarding_use_case.dart';
import 'features/core/domain/use_cases/fetch_banners_use_case.dart';
import 'features/core/domain/use_cases/fetch_driver_dropdown_use_case.dart';
import 'features/core/domain/use_cases/fetch_summary_use_case.dart';
import 'features/core/domain/use_cases/fetch_transport_mode_dropdown_use_case.dart';
import 'features/core/domain/use_cases/fetch_warehouse_dropdown_use_case.dart';
import 'features/core/presentation/cubit/core_cubit.dart';
import 'features/inventory/data/data_sources/inventory_remote_data_sources.dart';
import 'features/inventory/data/repositories/inventory_repositories_impl.dart';
import 'features/inventory/domain/repositories/inventory_repositories.dart';
import 'features/inventory/domain/use_cases/create_receive_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_delivery_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_inventories_count_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_inventories_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_preview_receive_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_prepare_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_receive_shipments_use_case.dart';
import 'features/inventory/presentation/cubit/inventory_cubit.dart';

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

  // Core
  getIt
    ..registerLazySingleton<CoreLocalDataSources>(
        () => CoreLocalDataSourcesImpl(storage: getIt.get()))
    ..registerLazySingleton<CoreRemoteDataSources>(
        () => CoreRemoteDataSourcesImpl(dio: getIt.get()))
    ..registerLazySingleton<CoreRepositories>(() => CoreRepositoriesImpl(
        coreLocalDataSources: getIt.get(), coreRemoteDataSources: getIt.get()))
    ..registerLazySingleton<CoreCubit>(() => CoreCubit(
        completeOnboardingUseCase:
            CompleteOnboardingUseCase(coreRepositories: getIt.get()),
        fetchBannersUseCase: FetchBannersUseCase(coreRepositories: getIt.get()),
        fetchDriverDropdownUseCase:
            FetchDriverDropdownUseCase(coreRepositories: getIt.get()),
        fetchSummaryUseCase: FetchSummaryUseCase(coreRepositories: getIt.get()),
        fetchTransportModeDropdownUseCase:
            FetchTransportModeDropdownUseCase(coreRepositories: getIt.get()),
        fetchWarehouseDropdownUseCase:
            FetchWarehouseDropdownUseCase(coreRepositories: getIt.get())));

  // Auth
  getIt
    ..registerLazySingleton<AuthLocalDataSources>(
        () => AuthLocalDataSourcesImpl(storage: getIt.get()))
    ..registerLazySingleton<AuthRemoteDataSources>(
        () => AuthRemoteDataSourcesImpl(dio: getIt.get()))
    ..registerLazySingleton<AuthRepositories>(() => AuthRepositoriesImpl(
        authLocalDataSources: getIt.get(), authRemoteDataSources: getIt.get()))
    ..registerLazySingleton<AuthCubit>(() => AuthCubit(
        fetchCurrentUserUseCase:
            FetchCurrentUserUseCase(authRepositories: getIt.get()),
        loginUseCase: LoginUseCase(authRepositories: getIt.get()),
        logoutUseCase: LogoutUseCase(authRepositories: getIt.get())));

  // Inventory
  getIt
    ..registerLazySingleton<InventoryRemoteDataSources>(
        () => InventoryRemoteDataSourcesImpl(dio: getIt.get()))
    ..registerLazySingleton<InventoryRepositories>(() =>
        InventoryRepositoriesImpl(inventoryRemoteDataSources: getIt.get()))
    ..registerLazySingleton<InventoryCubit>(() => InventoryCubit(
        createReceiveShipmentsUseCase:
            CreateReceiveShipmentsUseCase(inventoryRepositories: getIt.get()),
        fetchDeliveryShipmentsUseCase:
            FetchDeliveryShipmentsUseCase(inventoryRepositories: getIt.get()),
        fetchInventoriesUseCase:
            FetchInventoriesUseCase(inventoryRepositories: getIt.get()),
        fetchInventoriesCountUseCase:
            FetchInventoriesCountUseCase(inventoryRepositories: getIt.get()),
        fetchOnTheWayShipmentsUseCase:
            FetchOnTheWayShipmentsUseCase(inventoryRepositories: getIt.get()),
        fetchPreviewReceiveShipmentsUseCase:
            FetchPreviewReceiveShipmentsUseCase(
                inventoryRepositories: getIt.get()),
        fetchPrepareShipmentsUseCase:
            FetchPrepareShipmentsUseCase(inventoryRepositories: getIt.get()),
        fetchReceiveShipmentsUseCase:
            FetchReceiveShipmentsUseCase(inventoryRepositories: getIt.get())));
}
