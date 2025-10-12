import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/utils/dio_interceptor.dart';
import 'features/auth/data/data_sources/auth_local_data_sources.dart';
import 'features/auth/data/data_sources/auth_remote_data_sources.dart';
import 'features/auth/data/repositories/auth_repositories_impl.dart';
import 'features/auth/domain/repositories/auth_repositories.dart';
import 'features/auth/domain/use_cases/fetch_current_user_use_case.dart';
import 'features/auth/domain/use_cases/get_access_token_use_case.dart';
import 'features/auth/domain/use_cases/login_use_case.dart';
import 'features/auth/domain/use_cases/logout_use_case.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/core/data/data_sources/core_local_data_source.dart';
import 'features/core/data/data_sources/core_remote_data_source.dart';
import 'features/core/data/repositories/core_repository_impl.dart';
import 'features/core/domain/repositories/core_repository.dart';
import 'features/core/domain/use_cases/complete_onboarding_use_case.dart';
import 'features/core/domain/use_cases/fetch_banners_use_case.dart';
import 'features/core/domain/use_cases/fetch_driver_dropdown_use_case.dart';
import 'features/core/domain/use_cases/fetch_notifications_use_case.dart';
import 'features/core/domain/use_cases/fetch_summary_use_case.dart';
import 'features/core/domain/use_cases/fetch_transport_mode_dropdown_use_case.dart';
import 'features/core/domain/use_cases/fetch_warehouse_dropdown_use_case.dart';
import 'features/core/domain/use_cases/get_onboarding_status_use_case.dart';
import 'features/core/domain/use_cases/read_all_notifications_use_case.dart';
import 'features/core/domain/use_cases/read_notification_use_case.dart';
import 'features/core/presentation/cubit/core_cubit.dart';
import 'features/inventory/data/data_sources/inventory_remote_data_sources.dart';
import 'features/inventory/data/repositories/inventory_repositories_impl.dart';
import 'features/inventory/domain/repositories/inventory_repositories.dart';
import 'features/inventory/domain/use_cases/create_delivery_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/create_picked_up_goods_use_case.dart';
import 'features/inventory/domain/use_cases/create_prepare_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/create_receive_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/delete_prepared_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_delivery_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_good_timeline_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_inventories_count_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_inventories_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_lost_good_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_picked_up_goods_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_prepare_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_preview_delivery_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_preview_pick_up_goods_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_preview_prepare_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_preview_receive_shipments_use_case.dart';
import 'features/inventory/domain/use_cases/fetch_receive_shipments_use_case.dart';
import 'features/inventory/presentation/cubit/delivery_cubit.dart';
import 'features/inventory/presentation/cubit/inventory_cubit.dart';
import 'features/inventory/presentation/cubit/prepare_cubit.dart';
import 'features/inventory/presentation/cubit/receive_cubit.dart';

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
    ),
  );

  // Core
  getIt
    ..registerLazySingleton<CoreLocalDataSource>(
        () => CoreLocalDataSourceImpl(storage: getIt()))
    ..registerLazySingleton<CoreRemoteDataSource>(
        () => CoreRemoteDataSourceImpl(dio: getIt()))
    ..registerLazySingleton<CoreRepository>(() => CoreRepositoryImpl(
        coreLocalDataSource: getIt(), coreRemoteDataSource: getIt()))
    ..registerSingleton(CompleteOnboardingUseCase(coreRepository: getIt()))
    ..registerSingleton(FetchBannersUseCase(coreRepository: getIt()))
    ..registerSingleton(FetchDriverDropdownUseCase(coreRepository: getIt()))
    ..registerSingleton(FetchNotificationsUseCase(coreRepository: getIt()))
    ..registerSingleton(FetchSummaryUseCase(coreRepository: getIt()))
    ..registerSingleton(
        FetchTransportModeDropdownUseCase(coreRepository: getIt()))
    ..registerSingleton(FetchWarehouseDropdownUseCase(coreRepository: getIt()))
    ..registerSingleton(GetOnboardingStatusUseCase(coreRepository: getIt()))
    ..registerSingleton(ReadAllNotificationsUseCase(coreRepository: getIt()))
    ..registerSingleton(ReadNotificationUseCase(coreRepository: getIt()))
    ..registerLazySingleton(() => CoreCubit(
        completeOnboardingUseCase: getIt(),
        fetchBannersUseCase: getIt(),
        fetchDriverDropdownUseCase: getIt(),
        fetchNotificationsUseCase: getIt(),
        fetchSummaryUseCase: getIt(),
        fetchTransportModeDropdownUseCase: getIt(),
        fetchWarehouseDropdownUseCase: getIt(),
        readAllNotificationsUseCase: getIt(),
        readNotificationUseCase: getIt()));

  // Auth
  getIt
    ..registerLazySingleton<AuthLocalDataSources>(
        () => AuthLocalDataSourcesImpl(storage: getIt()))
    ..registerLazySingleton<AuthRemoteDataSources>(
        () => AuthRemoteDataSourcesImpl(dio: getIt()))
    ..registerLazySingleton<AuthRepositories>(() => AuthRepositoriesImpl(
        authLocalDataSources: getIt(), authRemoteDataSources: getIt()))
    ..registerSingleton(FetchCurrentUserUseCase(authRepositories: getIt()))
    ..registerSingleton(GetAccessTokenUseCase(authRepositories: getIt()))
    ..registerSingleton(LoginUseCase(authRepositories: getIt()))
    ..registerSingleton(LogoutUseCase(authRepositories: getIt()))
    ..registerLazySingleton<AuthCubit>(() => AuthCubit(
        fetchCurrentUserUseCase: getIt(),
        getAccessTokenUseCase: getIt(),
        getOnboardingStatusUseCase: getIt(),
        loginUseCase: getIt(),
        logoutUseCase: getIt()));

  // Inventory
  getIt
    ..registerLazySingleton<InventoryRemoteDataSources>(
        () => InventoryRemoteDataSourcesImpl(dio: getIt()))
    ..registerLazySingleton<InventoryRepositories>(
        () => InventoryRepositoriesImpl(inventoryRemoteDataSources: getIt()))
    ..registerSingleton(
        CreateDeliveryShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        CreatePickedUpGoodsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        CreatePrepareShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        CreateReceiveShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        DeletePreparedShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchDeliveryShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchGoodTimelineUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(FetchInventoriesUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchInventoriesCountUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(FetchLostGoodUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchOnTheWayShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchPickedUpGoodsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchPrepareShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchPreviewDeliveryShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchPreviewPickUpGoodsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchPreviewPrepareShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchPreviewReceiveShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerSingleton(
        FetchReceiveShipmentsUseCase(inventoryRepositories: getIt()))
    ..registerLazySingleton<InventoryCubit>(() => InventoryCubit(
        createPickedUpGoodsUseCase: getIt(),
        fetchGoodTimelineUseCase: getIt(),
        fetchInventoriesUseCase: getIt(),
        fetchInventoriesCountUseCase: getIt(),
        fetchLostGoodUseCase: getIt(),
        fetchOnTheWayShipmentsUseCase: getIt(),
        fetchPickedUpGoodsUseCase: getIt(),
        fetchPreviewPickUpGoodsUseCase: getIt()))
    ..registerLazySingleton(() => ReceiveCubit(
        createReceiveShipmentsUseCase: getIt(),
        fetchReceiveShipmentsUseCase: getIt(),
        fetchPreviewReceiveShipmentsUseCase: getIt()))
    ..registerLazySingleton(() => PrepareCubit(
        createPrepareShipmentsUseCase: getIt(),
        deletePreparedShipmentsUseCase: getIt(),
        fetchPrepareShipmentsUseCase: getIt(),
        fetchPreviewPrepareShipmentsUseCase: getIt()))
    ..registerLazySingleton(() => DeliveryCubit(
        createDeliveryShipmentsUseCase: getIt(),
        fetchDeliveryShipmentsUseCase: getIt(),
        fetchPreviewDeliveryShipmentsUseCase: getIt()));

  getIt<Dio>()
      .interceptors
      .add(CustomInterceptor(getAccessTokenUseCase: getIt()));
}
