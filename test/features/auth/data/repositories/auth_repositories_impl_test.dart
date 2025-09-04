import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/internal_exception.dart';
import 'package:tri_express/core/exceptions/server_exception.dart';
import 'package:tri_express/core/failure/failure.dart';
import 'package:tri_express/features/auth/data/data_sources/auth_remote_data_sources.dart';
import 'package:tri_express/features/auth/data/models/user_model.dart';
import 'package:tri_express/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:tri_express/features/auth/domain/use_cases/login_use_case.dart';

class MockAuthRemoteDataSources extends Mock
    implements AuthRemoteDataSourcesImpl {}

void main() {
  late MockAuthRemoteDataSources mockAuthRemoteDataSources;
  late AuthRepositoriesImpl authRepositoriesImpl;

  setUp(() {
    mockAuthRemoteDataSources = MockAuthRemoteDataSources();
    authRepositoriesImpl =
        AuthRepositoriesImpl(authRemoteDataSources: mockAuthRemoteDataSources);
  });

  group(
    'fetch current user: ',
    () {
      test(
        'should return UserModel when request status code is 200',
        () async {
          // arrange
          final user = UserModel(
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
          expect(result, Right(user));
          verify(() => mockAuthRemoteDataSources.fetchCurrentUser());
          verifyNoMoreInteractions(mockAuthRemoteDataSources);
        },
      );

      test(
        'should return ServerFailure when request status code is not 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.fetchCurrentUser())
              .thenThrow(ServerException());

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
              .thenThrow(InternalException());

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
      final params = LoginParams(email: 'email', password: 'password');
      test(
        'should return UserModel when request status code is 200',
        () async {
          // arrange
          final user = UserModel(
            id: '-',
            warehouseId: '-',
            email: 'email',
            name: 'name',
            phoneNumber: 'phoneNumber',
            roles: [],
          );
          when(() => mockAuthRemoteDataSources.login(params: params))
              .thenAnswer((_) async => user);

          // act
          final result = await authRepositoriesImpl.login(params: params);

          // assert
          expect(result, Right(user));
        },
      );

      test(
        'should return ServerFailure when request status code is not 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.login(params: params))
              .thenThrow(ServerException());

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
              .thenThrow(InternalException());

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

          // act
          final result = await authRepositoriesImpl.logout();

          // assert
          expect(result, Right('Logout successful'));
        },
      );

      test(
        'should return ServerFailure when request status code is not 200',
        () async {
          // arrange
          when(() => mockAuthRemoteDataSources.logout())
              .thenThrow(ServerException());

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
              .thenThrow(InternalException());

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
