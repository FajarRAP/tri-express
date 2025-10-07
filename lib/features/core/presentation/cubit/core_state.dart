part of 'core_cubit.dart';

@immutable
sealed class CoreState {
  const CoreState();
}

final class CoreInitial extends CoreState {}

class CompleteOnboarding extends CoreState {
  const CompleteOnboarding();
}

class FetchBanners extends CoreState {
  const FetchBanners();
}

class FetchDropdown extends CoreState {
  const FetchDropdown();
}

class FetchNotifications extends CoreState {
  const FetchNotifications();
}

class FetchSummary extends CoreState {
  const FetchSummary();
}

class ReadAllNotifications extends CoreState {
  const ReadAllNotifications();
}

class ReadNotification extends CoreState {
  const ReadNotification();
}

class CompleteOnboardingLoading extends CompleteOnboarding {}

class CompleteOnboardingLoaded extends CompleteOnboarding {}

class CompleteOnboardingError extends CompleteOnboarding {
  const CompleteOnboardingError({required this.message});

  final String message;
}

class FetchBannersLoading extends FetchBanners {}

class FetchBannersLoaded extends FetchBanners {
  const FetchBannersLoaded({required this.banners});

  final List<String> banners;
}

class FetchBannersError extends FetchBanners {
  const FetchBannersError({required this.message});

  final String message;
}

class FetchDropdownLoading extends FetchDropdown {}

class FetchDropdownLoaded extends FetchDropdown {
  const FetchDropdownLoaded({required this.items});

  final List<DropdownEntity> items;
}

class FetchDropdownError extends FetchDropdown {
  const FetchDropdownError({required this.message});

  final String message;
}

class FetchNotificationsLoading extends FetchNotifications {}

class FetchNotificationsLoaded extends FetchNotifications {
  const FetchNotificationsLoaded({required this.notifications});

  final List<NotificationEntity> notifications;
}

class FetchNotificationsError extends FetchNotifications {
  const FetchNotificationsError({required this.message});

  final String message;
}

class FetchSummaryLoading extends FetchSummary {}

class FetchSummaryLoaded extends FetchSummary {
  const FetchSummaryLoaded({required this.summary});

  final List<int> summary;
}

class FetchSummaryError extends FetchSummary {
  const FetchSummaryError({required this.message});

  final String message;
}

class ReadAllNotificationsLoading extends ReadAllNotifications {}

class ReadAllNotificationsLoaded extends ReadAllNotifications {
  const ReadAllNotificationsLoaded({required this.message});

  final String message;
}

class ReadAllNotificationsError extends ReadAllNotifications {
  const ReadAllNotificationsError({required this.message});

  final String message;
}

class ReadNotificationLoading extends ReadNotification {}

class ReadNotificationLoaded extends ReadNotification {
  const ReadNotificationLoaded({required this.message});

  final String message;
}

class ReadNotificationError extends ReadNotification {
  const ReadNotificationError({required this.message});

  final String message;
}
