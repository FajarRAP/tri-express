import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tri_express/features/core/domain/use_cases/fetch_driver_dropdown_use_case.dart';

import '../../../../core/use_case/use_case.dart';
import '../../domain/entities/dropdown_entity.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../../domain/use_cases/fetch_banners_use_case.dart';
import '../../domain/use_cases/fetch_summary_use_case.dart';
import '../../domain/use_cases/fetch_transport_mode_dropdown_use_case.dart';
import '../../domain/use_cases/fetch_warehouse_dropdown_use_case.dart';

part 'core_state.dart';

class CoreCubit extends Cubit<CoreState> {
  CoreCubit({
    required CompleteOnboardingUseCase completeOnboardingUseCase,
    required FetchBannersUseCase fetchBannersUseCase,
    required FetchDriverDropdownUseCase fetchDriverDropdownUseCase,
    required FetchSummaryUseCase fetchSummaryUseCase,
    required FetchTransportModeDropdownUseCase
        fetchTransportModeDropdownUseCase,
    required FetchWarehouseDropdownUseCase fetchWarehouseDropdownUseCase,
  })  : _completeOnboardingUseCase = completeOnboardingUseCase,
        _fetchBannersUseCase = fetchBannersUseCase,
        _fetchDriverDropdownUseCase = fetchDriverDropdownUseCase,
        _fetchSummaryUseCase = fetchSummaryUseCase,
        _fetchTransportModeDropdownUseCase = fetchTransportModeDropdownUseCase,
        _fetchWarehouseDropdownUseCase = fetchWarehouseDropdownUseCase,
        super(CoreInitial());

  final CompleteOnboardingUseCase _completeOnboardingUseCase;
  final FetchBannersUseCase _fetchBannersUseCase;
  final FetchDriverDropdownUseCase _fetchDriverDropdownUseCase;
  final FetchSummaryUseCase _fetchSummaryUseCase;
  final FetchTransportModeDropdownUseCase _fetchTransportModeDropdownUseCase;
  final FetchWarehouseDropdownUseCase _fetchWarehouseDropdownUseCase;

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
      (items) => emit(FetchDropdownLoaded(items: items)),
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
      (items) => emit(FetchDropdownLoaded(items: items)),
    );
  }

  Future<void> fetchWarehouseDropdown() async {
    emit(FetchDropdownLoading());

    final result = await _fetchWarehouseDropdownUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchDropdownError(message: failure.message)),
      (items) => emit(FetchDropdownLoaded(items: items)),
    );
  }
}
