import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/internal_exception.dart';
import 'package:tri_express/core/exceptions/server_exception.dart';
import 'package:tri_express/core/failure/failure.dart';
import 'package:tri_express/features/auth/data/data_sources/auth_local_data_sources.dart';
import 'package:tri_express/features/auth/data/data_sources/auth_remote_data_sources.dart';
import 'package:tri_express/features/auth/data/models/login_response_model.dart';
import 'package:tri_express/features/auth/data/models/user_model.dart';
import 'package:tri_express/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:tri_express/features/auth/domain/use_cases/login_use_case.dart';

class MockAuthRemoteDataSources extends Mock
    implements AuthRemoteDataSourcesImpl {}

class MockAuthLocalDataSources extends Mock
    implements AuthLocalDataSourcesImpl {}

void main() {
  late MockAuthRemoteDataSources mockAuthRemoteDataSources;
  late MockAuthLocalDataSources mockAuthLocalDataSources;
  late AuthRepositoriesImpl authRepositoriesImpl;

  setUp(() {
    mockAuthRemoteDataSources = MockAuthRemoteDataSources();
    mockAuthLocalDataSources = MockAuthLocalDataSources();
    authRepositoriesImpl = AuthRepositoriesImpl(
      authLocalDataSources: mockAuthLocalDataSources,
      authRemoteDataSources: mockAuthRemoteDataSources,
    );
  });

  group(
    'fetch current user: ',
    () {
      test(
        'should return UserModel when request status code is 200',
        () async {
          // arrange
          const user = UserModel(
            id: '-',
            warehouseId: '-',
            email: 'email',
            name: 'name',
            phoneNumber: 'phoneNumber',
            roles: [],
          );
          when(() => mockAuthRemoteDataSources.fetchCurrentUser())
              .thenAnswer((_) async => user);

          // act
          final result = await authRepositoriesImpl.fetchCurrentUser();

          // assert
          expect(result, const Right(user));
        },
      );

      test(
        'should return ServerFailure when request status code is not 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.fetchCurrentUser())
              .thenThrow(const ServerException());

          // act
          final result = await authRepositoriesImpl.fetchCurrentUser();

          // assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (success) => fail('Expected Left, but got Right'),
          );
        },
      );

      test(
        'should return Failure when unexpected error occurs',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.fetchCurrentUser())
              .thenThrow(const InternalException());

          // act
          final result = await authRepositoriesImpl.fetchCurrentUser();

          // assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<Failure>()),
            (success) => fail('Expected Left, but got Right'),
          );
        },
      );
    },
  );

  group(
    'login: ',
    () {
      const params = LoginParams(email: 'email', password: 'password');
      const tAccessToken = 'access_token';
      const tRefreshToken = 'refresh_token';

      test(
        'should return LoginResponseModel when request status code is 200',
        () async {
          // arrange
          const user = UserModel(
            id: '-',
            warehouseId: '-',
            email: 'email',
            name: 'name',
            phoneNumber: 'phoneNumber',
            roles: [],
          );
          const loginResponse = LoginResponseModel(
              user: user,
              accessToken: tAccessToken,
              refreshToken: tRefreshToken);
          when(() => mockAuthRemoteDataSources.login(params: params))
              .thenAnswer((_) async => loginResponse);
          when(() => mockAuthLocalDataSources.cacheToken(
                  accessToken: loginResponse.accessToken,
                  refreshToken: loginResponse.refreshToken))
              .thenAnswer((_) async {});

          // act
          final result = await authRepositoriesImpl.login(params: params);

          // assert
          expect(result, const Right(user));
          verify(() => mockAuthLocalDataSources.cacheToken(
              accessToken: loginResponse.accessToken,
              refreshToken: loginResponse.refreshToken)).called(1);
        },
      );

      test(
        'should return ServerFailure when request status code is not 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.login(params: params))
              .thenThrow(const ServerException());

          // act
          final result = await authRepositoriesImpl.login(params: params);

          // assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (success) => fail('Expected Left, but got Right'),
          );
        },
      );

      test(
        'should return Failure when unexpected error occurs',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.login(params: params))
              .thenThrow(const InternalException());

          // act
          final result = await authRepositoriesImpl.login(params: params);

          // assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<Failure>()),
            (success) => fail('Expected Left, but got Right'),
          );
        },
      );
    },
  );

  group(
    'logout: ',
    () {
      test(
        'should return String when request status code is 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.logout())
              .thenAnswer((_) async => 'Logout successful');
          when(() => mockAuthLocalDataSources.clearToken())
              .thenAnswer((_) async {});

          // act
          final result = await authRepositoriesImpl.logout();

          // assert
          expect(result, const Right('Logout successful'));
          verify(() => mockAuthLocalDataSources.clearToken()).called(1);
        },
      );

      test(
        'should return ServerFailure when request status code is not 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.logout())
              .thenThrow(const ServerException());

          // act
          final result = await authRepositoriesImpl.logout();

          // assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (success) => fail('Expected Left, but got Right'),
          );
        },
      );

      test(
        'should return Failure when unexpected error occurs',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.logout())
              .thenThrow(const InternalException());

          // act
          final result = await authRepositoriesImpl.logout();

          // assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<Failure>()),
            (success) => fail('Expected Left, but got Right'),
          );
        },
      );
    },
  );
}
