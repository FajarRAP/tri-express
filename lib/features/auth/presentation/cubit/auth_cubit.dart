import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/use_case/use_case.dart';
import '../../../core/domain/use_cases/get_onboarding_status_use_case.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/fetch_current_user_use_case.dart';
import '../../domain/use_cases/get_access_token_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/update_user_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required FetchCurrentUserUseCase fetchCurrentUserUseCase,
    required GetAccessTokenUseCase getAccessTokenUseCase,
    required GetOnboardingStatusUseCase getOnboardingStatusUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required UpdateUserUseCase updateUserUseCase,
  })  : _fetchCurrentUserUseCase = fetchCurrentUserUseCase,
        _getAccessTokenUseCase = getAccessTokenUseCase,
        _getOnboardingStatusUseCase = getOnboardingStatusUseCase,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _updateUserUseCase = updateUserUseCase,
        super(AuthInitial());

  final FetchCurrentUserUseCase _fetchCurrentUserUseCase;
  final GetAccessTokenUseCase _getAccessTokenUseCase;
  final GetOnboardingStatusUseCase _getOnboardingStatusUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  late UserEntity user;

  Future<void> fetchCurrentUser() async {
    emit(FetchCurrentUserLoading());

    final result = await _fetchCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchCurrentUserError(message: failure.message)),
      (user) => emit(FetchCurrentUserLoaded(user: this.user = user)),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    final params = LoginUseCaseParams(email: email, password: password);
    final result = await _loginUseCase(params);

    result.fold(
      (failure) => emit(LoginError(message: failure.message)),
      (user) => emit(LoginLoaded(user: this.user = user)),
    );
  }

  Future<void> logout() async {
    emit(LogoutLoading());

    final result = await _logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(LogoutError(message: failure.message)),
      (message) => emit(LogoutLoaded(message: message)),
    );
  }

  Future<void> checkAuthentication() async {
    emit(CheckingAuthentication());
    String? onboardingStatus;
    String? accessToken;

    final onboardingResult = await _getOnboardingStatusUseCase(NoParams());

    onboardingResult.fold(
        (failure) =>
            emit(CheckingAuthenticationError(message: failure.message)),
        (status) => onboardingStatus = status);

    if (onboardingStatus == null) {
      return emit(FirstTimeUser());
    }

    final accessTokenResult = await _getAccessTokenUseCase(NoParams());

    accessTokenResult.fold(
        (failure) =>
            emit(CheckingAuthenticationError(message: failure.message)),
        (token) => accessToken = token);

    accessToken == null ? emit(Unauthenticated()) : emit(Authenticated());
  }

  Future<void> updateUser({
    required String name,
    required String email,
    String? phoneNumber,
    String? password,
    String? avatarPath,
  }) async {
    emit(UpdateUserLoading());

    final params = UpdateUserUseCaseParams(
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      password: password,
      avatarPath: avatarPath,
    );
    final result = await _updateUserUseCase(params);

    result.fold(
      (failure) => emit(UpdateUserError(message: failure.message)),
      (message) => emit(UpdateUserLoaded(message: message)),
    );
  }
}
