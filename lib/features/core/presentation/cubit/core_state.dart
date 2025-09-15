part of 'core_cubit.dart';

@immutable
sealed class CoreState {}

final class CoreInitial extends CoreState {}

class CompleteOnboarding extends CoreState {}

class FetchBanners extends CoreState {}

class FetchSummary extends CoreState {}

class FetchDropdown extends CoreState {}

class CompleteOnboardingLoading extends CompleteOnboarding {}

class CompleteOnboardingLoaded extends CompleteOnboarding {}

class CompleteOnboardingError extends CompleteOnboarding {
  CompleteOnboardingError({required this.message});

  final String message;
}

class FetchBannersLoading extends FetchBanners {}

class FetchBannersLoaded extends FetchBanners {
  FetchBannersLoaded({required this.banners});

  final List<String> banners;
}

class FetchBannersError extends FetchBanners {
  FetchBannersError({required this.message});

  final String message;
}

class FetchSummaryLoading extends FetchSummary {}

class FetchSummaryLoaded extends FetchSummary {
  FetchSummaryLoaded({required this.summary});

  final List<int> summary;
}

class FetchSummaryError extends FetchSummary {
  FetchSummaryError({required this.message});

  final String message;
}

class FetchDropdownLoading extends FetchDropdown {}

class FetchDropdownLoaded extends FetchDropdown {
  FetchDropdownLoaded({required this.items});

  final List<DropdownEntity> items;
}

class FetchDropdownError extends FetchDropdown {
  FetchDropdownError({required this.message});

  final String message;
}
