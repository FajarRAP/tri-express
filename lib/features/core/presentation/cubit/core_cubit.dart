import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/use_case/use_case.dart';
import '../../domain/entities/dropdown_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../../domain/use_cases/fetch_banners_use_case.dart';
import '../../domain/use_cases/fetch_driver_dropdown_use_case.dart';
import '../../domain/use_cases/fetch_notifications_use_case.dart';
import '../../domain/use_cases/fetch_summary_use_case.dart';
import '../../domain/use_cases/fetch_transport_mode_dropdown_use_case.dart';
import '../../domain/use_cases/fetch_warehouse_dropdown_use_case.dart';
import '../../domain/use_cases/read_all_notifications_use_case.dart';
import '../../domain/use_cases/read_notification_use_case.dart';

part 'core_state.dart';

class CoreCubit extends Cubit<CoreState> {
  CoreCubit({
    required CompleteOnboardingUseCase completeOnboardingUseCase,
    required FetchBannersUseCase fetchBannersUseCase,
    required FetchDriverDropdownUseCase fetchDriverDropdownUseCase,
    required FetchNotificationsUseCase fetchNotificationsUseCase,
    required FetchSummaryUseCase fetchSummaryUseCase,
    required FetchTransportModeDropdownUseCase
        fetchTransportModeDropdownUseCase,
    required FetchWarehouseDropdownUseCase fetchWarehouseDropdownUseCase,
    required ReadAllNotificationsUseCase readAllNotificationsUseCase,
    required ReadNotificationUseCase readNotificationUseCase,
  })  : _completeOnboardingUseCase = completeOnboardingUseCase,
        _fetchBannersUseCase = fetchBannersUseCase,
        _fetchDriverDropdownUseCase = fetchDriverDropdownUseCase,
        _fetchNotificationsUseCase = fetchNotificationsUseCase,
        _fetchSummaryUseCase = fetchSummaryUseCase,
        _fetchTransportModeDropdownUseCase = fetchTransportModeDropdownUseCase,
        _fetchWarehouseDropdownUseCase = fetchWarehouseDropdownUseCase,
        _readAllNotificationsUseCase = readAllNotificationsUseCase,
        _readNotificationUseCase = readNotificationUseCase,
        super(CoreInitial());

  final CompleteOnboardingUseCase _completeOnboardingUseCase;
  final FetchBannersUseCase _fetchBannersUseCase;
  final FetchDriverDropdownUseCase _fetchDriverDropdownUseCase;
  final FetchNotificationsUseCase _fetchNotificationsUseCase;
  final FetchSummaryUseCase _fetchSummaryUseCase;
  final FetchTransportModeDropdownUseCase _fetchTransportModeDropdownUseCase;
  final FetchWarehouseDropdownUseCase _fetchWarehouseDropdownUseCase;
  final ReadAllNotificationsUseCase _readAllNotificationsUseCase;
  final ReadNotificationUseCase _readNotificationUseCase;

  Future<void> completeOnboarding() async {
    emit(CompleteOnboardingLoading());

    final result = await _completeOnboardingUseCase(NoParams());

    result.fold(
      (failure) => emit(CompleteOnboardingError(message: failure.message)),
      (_) => emit(CompleteOnboardingLoaded()),
    );
  }

  Future<void> fetchBanners() async {
    emit(FetchBannersLoading());

    final result = await _fetchBannersUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchBannersError(message: failure.message)),
      (banners) => emit(FetchBannersLoaded(banners: banners)),
    );
  }

  Future<void> fetchDriverDropdown() async {
    emit(FetchDropdownLoading());

    final result = await _fetchDriverDropdownUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchDropdownError(message: failure.message)),
      (items) => emit(FetchDropdownLoaded(items: items, filteredItems: items)),
    );
  }

  Future<void> fetchNotifications() async {
    emit(FetchNotificationsLoading());

    final result = await _fetchNotificationsUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchNotificationsError(message: failure.message)),
      (notifications) =>
          emit(FetchNotificationsLoaded(notifications: notifications)),
    );
  }

  Future<void> fetchSummary() async {
    emit(FetchSummaryLoading());

    final result = await _fetchSummaryUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchSummaryError(message: failure.message)),
      (summary) => emit(FetchSummaryLoaded(summary: summary)),
    );
  }

  Future<void> fetchTransportModeDropdown() async {
    emit(FetchDropdownLoading());

    final result = await _fetchTransportModeDropdownUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchDropdownError(message: failure.message)),
      (items) => emit(FetchDropdownLoaded(items: items, filteredItems: items)),
    );
  }

  Future<void> fetchWarehouseDropdown() async {
    emit(FetchDropdownLoading());

    final result = await _fetchWarehouseDropdownUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchDropdownError(message: failure.message)),
      (items) => emit(FetchDropdownLoaded(items: items, filteredItems: items)),
    );
  }

  Future<void> readAllNotifications() async {
    emit(ReadAllNotificationsLoading());

    final result = await _readAllNotificationsUseCase(NoParams());

    result.fold(
      (failure) => emit(ReadAllNotificationsError(message: failure.message)),
      (message) => emit(ReadAllNotificationsLoaded(message: message)),
    );
  }

  Future<void> readNotification(String notificationId) async {
    emit(ReadNotificationLoading());

    final result = await _readNotificationUseCase(notificationId);

    result.fold(
      (failure) => emit(ReadNotificationError(message: failure.message)),
      (message) => emit(ReadNotificationLoaded(message: message)),
    );
  }

  void searchDropdown([String keyword = '']) {
    final currentState = state;
    if (currentState is! FetchDropdownLoaded) return;

    if (keyword.isEmpty)
      return emit(currentState.copyWith(filteredItems: currentState.items));

    final lowerKeyword = keyword.toLowerCase();
    final results = currentState.items
        .where((e) => e.value.toLowerCase().contains(lowerKeyword))
        .toList();

    emit(currentState.copyWith(filteredItems: results));
  }
}
