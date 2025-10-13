import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/internal_exception.dart';
import 'package:tri_express/core/exceptions/server_exception.dart';
import 'package:tri_express/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tri_express/features/auth/data/models/login_response_model.dart';
import 'package:tri_express/features/auth/data/models/user_model.dart';
import 'package:tri_express/features/auth/domain/entities/user_entity.dart';
import 'package:tri_express/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tri_express/features/auth/domain/use_cases/update_user_use_case.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(dio: mockDio);
  });

  group(
    'fetch current user: ',
    () {
      test(
        'should return UserModel when the request status code is 200',
        () async {
          // arrange
          final jsonString =
              fixtureReader('data_sources/get_current_user.json');
          final json = jsonDecode(jsonString);

          when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
              data: json,
              requestOptions: RequestOptions(),
              statusCode: 200,
            ),
          );

          // act
          final result = await dataSource.fetchCurrentUser();

          // assert
          expect(result, isA<UserEntity>());
          expect(result, isNot(isA<UserModel>()));
        },
      );

      test(
        'should return ServerException when response status code is not 200',
        () async {
          // arrange
          when(() => mockDio.get(any())).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              response: Response(
                data: {'message': 'Not Found'},
                requestOptions: RequestOptions(),
                statusCode: 404,
              ),
            ),
          );

          // act
          final result = dataSource.fetchCurrentUser();

          // assert
          await expectLater(result, throwsA(isA<ServerException>()));
        },
      );

      test(
        'should return InternalException when unexpected error occurs',
        () async {
          // arrange
          when(() => mockDio.get(any())).thenThrow(const InternalException());

          // act
          final result = dataSource.fetchCurrentUser();

          // assert
          await expectLater(result, throwsA(isA<InternalException>()));
        },
      );
    },
  );

  group(
    'login: ',
    () {
      const params = LoginUseCaseParams(email: 'email', password: 'password');
      test(
        'should return UserModel when the request status code is 200',
        () async {
          // arrange
          final jsonString = fixtureReader('data_sources/login.json');
          final json = jsonDecode(jsonString);

          when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
            (_) async => Response(
              data: json,
              requestOptions: RequestOptions(),
              statusCode: 200,
            ),
          );

          // act
          final result = await dataSource.login(params);

          // assert
          expect(result, isA<LoginResponseModel>());
        },
      );

      test(
        'should return ServerException when response status code is not 200',
        () async {
          // arrange
          when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              response: Response(
                data: {'message': 'Not Found'},
                requestOptions: RequestOptions(),
                statusCode: 404,
              ),
            ),
          );

          // act
          final result = dataSource.login(params);

          // assert
          await expectLater(result, throwsA(isA<ServerException>()));
        },
      );

      test(
        'should return InternalException when unexpected error occurs',
        () async {
          // arrange
          when(() => mockDio.post(any())).thenThrow(const InternalException());

          // act
          final result = dataSource.login(params);

          // assert
          await expectLater(result, throwsA(isA<InternalException>()));
        },
      );
    },
  );

  group(
    'logout: ',
    () {
      test(
        'should return String when the request status code is 200',
        () async {
          // arrange
          const json = <String, dynamic>{
            'status': 'Success',
            'message': 200,
            'data':
                'You have successfully logged out and the token was successfully deleted'
          };
          when(() => mockDio.post(any())).thenAnswer(
            (_) async => Response(
              data: json,
              requestOptions: RequestOptions(),
              statusCode: 200,
            ),
          );

          // act
          final result = await dataSource.logout();

          // assert
          expect(result, isA<String>());
        },
      );

      test(
        'should return ServerException when response status code is not 200',
        () async {
          // arrange
          when(() => mockDio.post(any())).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              response: Response(
                data: {'message': 'Not Found'},
                requestOptions: RequestOptions(),
                statusCode: 404,
              ),
            ),
          );

          // act
          final result = dataSource.logout();

          // assert
          await expectLater(result, throwsA(isA<ServerException>()));
        },
      );

      test(
        'should return InternalException when unexpected error occurs',
        () async {
          // arrange
          when(() => mockDio.post(any())).thenThrow(const InternalException());

          // act
          final result = dataSource.logout();

          // assert
          await expectLater(result, throwsA(isA<InternalException>()));
        },
      );
    },
  );

  group('update user remote data sources test', () {
    const params = UpdateUserUseCaseParams(
      name: 'name',
      email: 'email',
    );

    test('should return String when request status code is 200', () async {
      // arrange
      final jsonString = fixtureReader('data_sources/update_user.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.updateUser(params);

      // assert
      expect(result, isA<String>());
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            data: {'message': 'Unauthorized'},
            statusCode: 401,
          ),
        ),
      );

      // act
      final result = dataSource.updateUser(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(Exception('Unexpected error happen'));

      // act
      final result = dataSource.updateUser(params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });
}
