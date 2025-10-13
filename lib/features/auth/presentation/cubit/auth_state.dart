part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class Login extends AuthState {}

class UpdateUser extends AuthState {}

class LoginLoading extends Login {}

class LoginLoaded extends Login {
  LoginLoaded({required this.user});

  final UserEntity user;
}

class LoginError extends Login {
  LoginError({required this.message});

  final String message;
}

class Logout extends AuthState {}

class LogoutLoading extends Logout {}

class LogoutLoaded extends Logout {
  LogoutLoaded({required this.message});

  final String message;
}

class LogoutError extends Logout {
  LogoutError({required this.message});

  final String message;
}

class FetchCurrentUser extends AuthState {}

class FetchCurrentUserLoading extends FetchCurrentUser {}

class FetchCurrentUserLoaded extends FetchCurrentUser {
  FetchCurrentUserLoaded({required this.user});

  final UserEntity user;
}

class FetchCurrentUserError extends FetchCurrentUser {
  FetchCurrentUserError({required this.message});

  final String message;
}

class CheckingAuthentication extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class FirstTimeUser extends AuthState {}

class CheckingAuthenticationError extends AuthState {
  CheckingAuthenticationError({required this.message});

  final String message;
}

class UpdateUserLoading extends UpdateUser {}

class UpdateUserLoaded extends UpdateUser {
  UpdateUserLoaded({required this.message});

  final String message;
}

class UpdateUserError extends UpdateUser {
  UpdateUserError({required this.message});

  final String message;
}
