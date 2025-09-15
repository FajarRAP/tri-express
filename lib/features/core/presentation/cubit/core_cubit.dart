import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/use_case/use_case.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../../domain/use_cases/fetch_banners_use_case.dart';
import '../../domain/use_cases/fetch_summary_use_case.dart';

part 'core_state.dart';

class CoreCubit extends Cubit<CoreState> {
  CoreCubit({
    required CompleteOnboardingUseCase completeOnboardingUseCase,
    required FetchBannersUseCase fetchBannersUseCase,
    required FetchSummaryUseCase fetchSummaryUseCase,
  })  : _completeOnboardingUseCase = completeOnboardingUseCase,
        _fetchBannersUseCase = fetchBannersUseCase,
        _fetchSummaryUseCase = fetchSummaryUseCase,
        super(CoreInitial());

  final CompleteOnboardingUseCase _completeOnboardingUseCase;
  final FetchBannersUseCase _fetchBannersUseCase;
  final FetchSummaryUseCase _fetchSummaryUseCase;

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

  Future<void> fetchSummary() async {
    emit(FetchSummaryLoading());

    final result = await _fetchSummaryUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchSummaryError(message: failure.message)),
      (summary) => emit(FetchSummaryLoaded(summary: summary)),
    );
  }
}
