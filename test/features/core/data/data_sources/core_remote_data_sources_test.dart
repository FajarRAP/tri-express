import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/internal_exception.dart';
import 'package:tri_express/core/exceptions/server_exception.dart';
import 'package:tri_express/features/core/data/data_sources/core_remote_data_source.dart';
import 'package:tri_express/features/core/data/models/dropdown_model.dart';
import 'package:tri_express/features/core/data/models/notification_model.dart';
import 'package:tri_express/features/core/domain/entities/dropdown_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late CoreRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = CoreRemoteDataSourceImpl(dio: mockDio);
  });

  group(
    'fetch banners remote data source',
    () {
      test(
        'should return List<String> when request is successful',
        () async {
          // arrange
          const json = <String, dynamic>{
            'status': 'Success',
            'message': 'data summary',
            'data': [
              {
                'id': '01991817-f390-72c0-b2bf-bbb8dd108cf2',
                'title': 'Night Landscape',
                'foto': 'banner/VtNM9FxD94U7zd0zRqS79mVFMFDUmsrJSK7kBMC9.jpg',
                'status': 1,
                'created_at': '2025-09-05T04:17:26.000000Z',
                'updated_at': '2025-09-05T04:17:46.000000Z',
                'foto_url':
                    'http://159.65.13.17/storage/banner/VtNM9FxD94U7zd0zRqS79mVFMFDUmsrJSK7kBMC9.jpg'
              }
            ]
          };
          when(() => mockDio.get(any())).thenAnswer((_) async => Response(
              data: json, requestOptions: RequestOptions(), statusCode: 200));

          // act
          final result = await dataSource.fetchBanners();

          // assert
          expect(result, isA<List<String>>());
        },
      );
    },
  );

  group(
    'fetch summary remote data source',
    () {
      test(
        'should return List<int> when request is successful',
        () async {
          // arrange
          const json = <String, dynamic>{
            'status': 'Success',
            'message': 'data summary',
            'data': {'ontheway': 0, 'diterima': 0, 'dikirim': 0}
          };
          when(() => mockDio.get(any())).thenAnswer((_) async => Response(
              data: json, requestOptions: RequestOptions(), statusCode: 200));

          // act
          final result = await dataSource.fetchSummary();

          // assert
          expect(result, isA<List<int>>());
        },
      );
    },
  );

  group(
    'fetch transport mode dropdown remote data source',
    () {
      test(
        'should return List<DropdownEntity> when request is successful',
        () async {
          // arrange
          final jsonString =
              fixtureReader('data_sources/get_transport_mode_dropdown.json');
          final json = jsonDecode(jsonString);
          when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
                data: json, requestOptions: RequestOptions(), statusCode: 200),
          );

          // act
          final result = await dataSource.fetchTransportModeDropdown();

          // assert
          expect(result, isNot(isA<List<DropdownModel>>()));
          expect(result, isA<List<DropdownEntity>>());
        },
      );
    },
  );

  group(
    'fetch warehouse dropdown remote data source',
    () {
      test(
        'should return List<DropdownEntity> when request is successful',
        () async {
          // arrange
          final jsonString =
              fixtureReader('data_sources/get_warehouse_dropdown.json');
          final json = jsonDecode(jsonString);
          when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
                data: json, requestOptions: RequestOptions(), statusCode: 200),
          );

          // act
          final result = await dataSource.fetchWarehouseDropdown();

          // assert
          expect(result, isNot(isA<List<DropdownModel>>()));
          expect(result, isA<List<DropdownEntity>>());
        },
      );
    },
  );

  group(
    'fetch driver dropdown remote data source',
    () {
      test(
        'should return List<DropdownEntity> when request is successful',
        () async {
          // arrange
          final jsonString =
              fixtureReader('data_sources/get_driver_dropdown.json');
          final json = jsonDecode(jsonString);
          when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
                data: json, requestOptions: RequestOptions(), statusCode: 200),
          );

          // act
          final result = await dataSource.fetchDriverDropdown();

          // assert
          expect(result, isNot(isA<List<DropdownModel>>()));
          expect(result, isA<List<DropdownEntity>>());
        },
      );
    },
  );

  group('fetch notification remote data sources test', () {
    final tNotificationModel = NotificationModel(
      title: 'Pengiriman menuju gudangmu Gudang Palopo',
      message:
          'Barang dengan No Pengiriman #SHIP.2509241458249 dari Gudang Pekalongan via jalur Udara sedang dalam perjalanan ke gudangmu (5 koli).',
      createdAt: DateTime.parse('2025-09-24T08:01:06.000000Z'),
      readAt: null,
    );
    final entities = [tNotificationModel.toEntity()];

    test(
        'should return List<NotificationEntity> when request status code is 200',
        () async {
      // arrange
      final jsonString = fixtureReader('data_sources/get_notification.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.fetchNotifications();

      // assert
      expect(result, entities);
      expect(result, isNot(isA<List<NotificationModel>>()));
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.get(any())).thenThrow(
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
      final result = dataSource.fetchNotifications();

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.get(any()))
          .thenThrow(Exception('Unexpected error happen'));

      // act
      final result = dataSource.fetchNotifications();

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('read all notifications remote data sources test', () {
    const message = 'All notifications marked as read';
    
    test('should return String when request status code is 200', () async {
      // arrange
      final jsonString =
          fixtureReader('data_sources/get_read_all_notifications.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.readAllNotifications();

      // assert
      expect(result, message);
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.get(any())).thenThrow(
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
      final result = dataSource.readAllNotifications();

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.get(any()))
          .thenThrow(Exception('Unexpected error happen'));

      // act
      final result = dataSource.readAllNotifications();

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });
}
