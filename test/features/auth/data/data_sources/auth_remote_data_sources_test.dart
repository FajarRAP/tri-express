import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/internal_exception.dart';
import 'package:tri_express/core/exceptions/server_exception.dart';
import 'package:tri_express/features/auth/data/data_sources/auth_remote_data_sources.dart';
import 'package:tri_express/features/auth/data/models/user_model.dart';
import 'package:tri_express/features/auth/domain/use_cases/login_use_case.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataSourcesImpl authRemoteDataSources;

  setUp(() {
    mockDio = MockDio();
    authRemoteDataSources = AuthRemoteDataSourcesImpl(dio: mockDio);
  });

  group(
    'fetch current user: ',
    () {
      test(
        'should return UserModel when the request status code is 200',
        () async {
          // arrange
          const json = <String, dynamic>{
            "status": "Success",
            "message": "Detail Profil",
            "data": {
              "user": {
                "id": "019903c3-cc2c-70cb-a1c5-3a67463e6a7e",
                "gudang_id": null,
                "name": "superadmin",
                "email": "superadmin@domain.com",
                "no_telp": "+3786838692312",
                "email_verified_at": "2025-09-01T05:33:07.000000Z",
                "avatar": null,
                "status": 1,
                "created_at": "2025-09-01T05:33:07.000000Z",
                "updated_at": "2025-09-01T05:33:07.000000Z",
                "roles": [
                  {
                    "uuid": "019903c3-caf3-7095-84c4-d3130f098c10",
                    "name": "superadmin",
                    "guard_name": "web",
                    "created_at": "2025-09-01T05:33:07.000000Z",
                    "updated_at": "2025-09-01T05:33:07.000000Z",
                    "pivot": {
                      "model_type": "App\\Models\\User",
                      "model_uuid": "019903c3-cc2c-70cb-a1c5-3a67463e6a7e",
                      "role_id": "019903c3-caf3-7095-84c4-d3130f098c10"
                    }
                  }
                ]
              }
            }
          };
          when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
              data: json,
              requestOptions: RequestOptions(),
              statusCode: 200,
            ),
          );

          // act
          final result = await authRemoteDataSources.fetchCurrentUser();

          // assert
          expect(result, isA<UserModel>());
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
          final call = authRemoteDataSources.fetchCurrentUser;

          // assert
          expect(call, throwsA(isA<ServerException>()));
        },
      );

      test(
        'should return InternalException when unexpected error occurs',
        () async {
          // arrange
          when(() => mockDio.get(any())).thenThrow(InternalException());

          // act
          final call = authRemoteDataSources.fetchCurrentUser;

          // assert
          expect(call, throwsA(isA<InternalException>()));
        },
      );
    },
  );

  group(
    'login: ',
    () {
      final params = LoginParams(email: 'email', password: 'password');
      test(
        'should return UserModel when the request status code is 200',
        () async {
          // arrange
          const json = <String, dynamic>{
            "status": "Success",
            "message": "success login",
            "data": {
              "user": {
                "id": "019903c3-cc2c-70cb-a1c5-3a67463e6a7e",
                "gudang_id": null,
                "name": "superadmin",
                "email": "superadmin@domain.com",
                "no_telp": "+3786838692312",
                "email_verified_at": "2025-09-01T05:33:07.000000Z",
                "avatar": null,
                "status": 1,
                "created_at": "2025-09-01T05:33:07.000000Z",
                "updated_at": "2025-09-01T05:33:07.000000Z",
                "roles": [
                  {
                    "uuid": "019903c3-caf3-7095-84c4-d3130f098c10",
                    "name": "superadmin",
                    "guard_name": "web",
                    "created_at": "2025-09-01T05:33:07.000000Z",
                    "updated_at": "2025-09-01T05:33:07.000000Z",
                    "pivot": {
                      "model_type": "App\\Models\\User",
                      "model_uuid": "019903c3-cc2c-70cb-a1c5-3a67463e6a7e",
                      "role_id": "019903c3-caf3-7095-84c4-d3130f098c10"
                    }
                  }
                ]
              },
              "token": "5|tJic7kx7GY9otkdf4TBhOAQCvGKH1QLoWiTcjeFTa56bafd5",
              "role": "superadmin"
            }
          };
          when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
            (_) async => Response(
              data: json,
              requestOptions: RequestOptions(),
              statusCode: 200,
            ),
          );

          // act
          final result = await authRemoteDataSources.login(params: params);

          // assert
          expect(result, isA<UserModel>());
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
          final call = authRemoteDataSources.login;

          // assert
          expect(() => call(params: params), throwsA(isA<ServerException>()));
        },
      );

      test(
        'should return InternalException when unexpected error occurs',
        () async {
          // arrange
          when(() => mockDio.post(any())).thenThrow(InternalException());

          // act
          final call = authRemoteDataSources.login;

          // assert
          expect(() => call(params: params), throwsA(isA<InternalException>()));
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
          when(() => mockDio.post(any())).thenAnswer(
            (_) async => Response(
              data: {'message': 'succses logout'},
              requestOptions: RequestOptions(),
              statusCode: 200,
            ),
          );

          // act
          final result = await authRemoteDataSources.logout();

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
          final call = authRemoteDataSources.logout;

          // assert
          expect(call, throwsA(isA<ServerException>()));
        },
      );

      test(
        'should return InternalException when unexpected error occurs',
        () async {
          // arrange
          when(() => mockDio.post(any())).thenThrow(InternalException());

          // act
          final call = authRemoteDataSources.logout;

          // assert
          expect(call, throwsA(isA<InternalException>()));
        },
      );
    },
  );
}
