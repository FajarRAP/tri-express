import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/use_case/use_case.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/fetch_current_user_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required FetchCurrentUserUseCase fetchCurrentUserUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _fetchCurrentUserUseCase = fetchCurrentUserUseCase,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial());

  final FetchCurrentUserUseCase _fetchCurrentUserUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> fetchCurrentUser() async {
    emit(FetchCurrentUserLoading());

    final result = await _fetchCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(FetchCurrentUserError(message: failure.message)),
      (user) => emit(FetchCurrentUserLoaded(user: user)),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    final params = LoginParams(email: email, password: password);

    final result = await _loginUseCase(params);

    result.fold(
      (failure) => emit(LoginError(message: failure.message)),
      (user) => emit(LoginLoaded(user: user)),
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
}
