part of 'core_cubit.dart';

@immutable
sealed class CoreState {}

final class CoreInitial extends CoreState {}

class CompleteOnboarding extends CoreState {}

class FetchBanners extends CoreState {}

class CompleteOnboardingLoading extends CoreState {}

class CompleteOnboardingLoaded extends CoreState {}

class CompleteOnboardingError extends CoreState {
  CompleteOnboardingError({required this.message});

  final String message;
}

class FetchBannersLoading extends CoreState {}

class FetchBannersLoaded extends CoreState {
  FetchBannersLoaded({required this.banners});

  final List<String> banners;
}

class FetchBannersError extends CoreState {
  FetchBannersError({required this.message});

  final String message;
}
