import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/internal_exception.dart';
import 'package:tri_express/core/exceptions/server_exception.dart';
import 'package:tri_express/core/failure/failure.dart';
import 'package:tri_express/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:tri_express/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tri_express/features/auth/data/models/login_response_model.dart';
import 'package:tri_express/features/auth/data/models/user_model.dart';
import 'package:tri_express/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tri_express/features/auth/domain/use_cases/login_use_case.dart';

class MockAuthRemoteDataSource extends Mock
    implements AuthRemoteDataSourceImpl {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSourceImpl {}

void main() {
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    authRepositoryImpl = AuthRepositoryImpl(
      authLocalDataSource: mockAuthLocalDataSource,
      authRemoteDataSource: mockAuthRemoteDataSource,
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
          when(() => mockAuthRemoteDataSource.fetchCurrentUser())
              .thenAnswer((_) async => user);

          // act
          final result = await authRepositoryImpl.fetchCurrentUser();

          // assert
          expect(result, const Right(user));
        },
      );

      test(
        'should return ServerFailure when request status code is not 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSource.fetchCurrentUser())
              .thenThrow(const ServerException());

          // act
          final result = await authRepositoryImpl.fetchCurrentUser();

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
          when(() => mockAuthRemoteDataSource.fetchCurrentUser())
              .thenThrow(const InternalException());

          // act
          final result = await authRepositoryImpl.fetchCurrentUser();

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
      const params = LoginUseCaseParams(email: 'email', password: 'password');
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
          when(() => mockAuthRemoteDataSource.login(params))
              .thenAnswer((_) async => loginResponse);
          when(() => mockAuthLocalDataSource.cacheToken(
                  loginResponse.accessToken, loginResponse.refreshToken))
              .thenAnswer((_) async {});

          // act
          final result = await authRepositoryImpl.login(params);

          // assert
          expect(result, const Right(user));
          verify(() => mockAuthLocalDataSource.cacheToken(
              loginResponse.accessToken, loginResponse.refreshToken)).called(1);
        },
      );

      test(
        'should return ServerFailure when request status code is not 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSource.login(params))
              .thenThrow(const ServerException());

          // act
          final result = await authRepositoryImpl.login(params);

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
          when(() => mockAuthRemoteDataSource.login(params))
              .thenThrow(const InternalException());

          // act
          final result = await authRepositoryImpl.login(params);

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
          when(() => mockAuthRemoteDataSource.logout())
              .thenAnswer((_) async => 'Logout successful');
          when(() => mockAuthLocalDataSource.clearToken())
              .thenAnswer((_) async {});

          // act
          final result = await authRepositoryImpl.logout();

          // assert
          expect(result, const Right('Logout successful'));
          verify(() => mockAuthLocalDataSource.clearToken()).called(1);
        },
      );

      test(
        'should return ServerFailure when request status code is not 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSource.logout())
              .thenThrow(const ServerException());

          // act
          final result = await authRepositoryImpl.logout();

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
          when(() => mockAuthRemoteDataSource.logout())
              .thenThrow(const InternalException());

          // act
          final result = await authRepositoryImpl.logout();

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
