import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/internal_exception.dart';
import 'package:tri_express/core/exceptions/server_exception.dart';
import 'package:tri_express/features/core/domain/entities/dropdown_entity.dart';
import 'package:tri_express/features/inventory/data/data_sources/inventory_remote_data_sources.dart';
import 'package:tri_express/features/inventory/data/models/batch_model.dart';
import 'package:tri_express/features/inventory/data/models/good_model.dart';
import 'package:tri_express/features/inventory/data/models/picked_good_model.dart';
import 'package:tri_express/features/inventory/data/models/timeline_summary_model.dart';
import 'package:tri_express/features/inventory/domain/entities/batch_entity.dart';
import 'package:tri_express/features/inventory/domain/entities/good_entity.dart';
import 'package:tri_express/features/inventory/domain/entities/picked_good_entity.dart';
import 'package:tri_express/features/inventory/domain/entities/timeline_summary_entity.dart';
import 'package:tri_express/features/inventory/domain/use_cases/create_delivery_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/create_picked_up_goods_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/create_prepare_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/create_receive_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_delivery_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_inventories_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_picked_up_goods_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_prepare_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_preview_delivery_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_preview_receive_shipments_use_case.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late InventoryRemoteDataSourcesImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = InventoryRemoteDataSourcesImpl(dio: mockDio);
  });

  group('create delivery shipments remote data sources test', () {
    final params = CreateDeliveryShipmentsUseCaseParams(
      nextWarehouse: const DropdownEntity(
        id: '019903c3-ca71-713d-90a0-549aaea7e2d3',
        value: 'Gudang Tegal',
      ),
      driver: const DropdownEntity(
        id: '019908d1-635b-70d7-b012-194607f49d16',
        value: 'driver-value',
      ),
      uniqueCodes: ['A00000001760'],
      shipmentIds: ['100'],
      deliveredAt: DateTime.parse('2025-09-24'),
    );

    test('should return String when request status code is 200', () async {
      // arrange
      final jsonString =
          fixtureReader('data_sources/create_delivery_shipments.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.createDeliveryShipments(params);

      // assert
      expect(result, isA<String>());
      verify(() => mockDio.post(any(), data: {
            'next_warehouse_id': params.nextWarehouse.id,
            'delivery_date': params.deliveredAt.toIso8601String(),
            'user_id': params.driver.id,
            'codes': params.uniqueCodes,
            'shipment_ids': params.shipmentIds,
          })).called(1);
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
      final result = dataSource.createDeliveryShipments(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.createDeliveryShipments(params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('create prepare shipments remote data sources test', () {
    final params = CreatePrepareShipmentsUseCaseParams(
      shippedAt: DateTime.now(),
      estimatedAt: DateTime.now().add(const Duration(days: 3)),
      batchName: 'Batch A',
      nextWarehouse: const DropdownEntity(id: 'id', value: 'value'),
      transportMode: const DropdownEntity(id: 'id', value: 'value'),
      uniqueCodes: ['A00000000787', 'A00000000788', 'A00000000789'],
    );

    test('should return String when request status code is 200', () async {
      // arrange
      final jsonString =
          fixtureReader('data_sources/create_receive_shipments.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.createPrepareShipments(params);

      // assert
      expect(result, json['message']);
      verify(() => mockDio.post('/prepare/store', data: any(named: 'data')))
          .called(1);
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
      final result = dataSource.createPrepareShipments;

      // assert
      await expectLater(() => result(params), throwsA(isA<ServerException>()));
      verify(() => mockDio.post('/prepare/store', data: any(named: 'data')))
          .called(1);
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.createPrepareShipments;

      // assert
      await expectLater(
          () => result(params), throwsA(isA<InternalException>()));
      verify(() => mockDio.post('/prepare/store', data: any(named: 'data')))
          .called(1);
    });
  });

  group('create receive shipments remote data sources test', () {
    final params = CreateReceiveShipmentsUseCaseParams(
      receivedAt: DateTime.now(),
      uniqueCodes: ['A00000000787', 'A00000000788', 'A00000000789'],
    );

    test('should return String when request status code is 200', () async {
      // arrange
      final jsonString =
          fixtureReader('data_sources/create_receive_shipments.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.createReceiveShipments(params);

      // assert
      expect(result, json['message']);
      verify(() => mockDio.post('/receive/store', data: any(named: 'data')))
          .called(1);
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
      final result = dataSource.createReceiveShipments;

      // assert
      await expectLater(() => result(params), throwsA(isA<ServerException>()));
      verify(() => mockDio.post('/receive/store', data: any(named: 'data')))
          .called(1);
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.createReceiveShipments;

      // assert
      await expectLater(
          () => result(params), throwsA(isA<InternalException>()));
      verify(() => mockDio.post('/receive/store', data: any(named: 'data')))
          .called(1);
    });
  });

  group('delete prepared shipments remote data sources test', () {
    const params = '99';

    test('should return String when request status code is 200', () async {
      // arrange
      final jsonString =
          fixtureReader('data_sources/delete_prepared_shipments.json');
      final json = jsonDecode(jsonString);
      final message = json['message'];
      when(() => mockDio.delete(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.deletePreparedShipments(params);

      // assert
      expect(result, message);
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.delete(any())).thenThrow(
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
      final result = dataSource.deletePreparedShipments(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.delete(any())).thenThrow(const InternalException());

      // act
      final result = dataSource.deletePreparedShipments(params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('fetch delivery shipments remote data sources test', () {
    const params = FetchDeliveryShipmentsUseCaseParams(page: 1, perPage: 10);
    test(
      'should return List<BatchEntity> when the request status code is 200',
      () async {
        // arrange
        final jsonString =
            fixtureReader('data_sources/get_delivery_shipments.json');
        final jsonMap = jsonDecode(jsonString);
        when(() => mockDio.get(any(),
            queryParameters: any(named: 'queryParameters'))).thenAnswer(
          (_) async => Response(
            data: jsonMap,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        // act
        final result = await dataSource.fetchDeliveryShipments(params);

        // assert
        expect(result, isA<List<BatchEntity>>());
      },
    );
  });

  group('fetch inventories remote data sources test', () {
    const params =
        FetchInventoriesUseCaseParams(page: 1, perPage: 10, search: '');
    test(
      'should return List<BatchEntity> when the request status code is 200',
      () async {
        // arrange
        final jsonString = fixtureReader('data_sources/get_inventories.json');
        final jsonMap = jsonDecode(jsonString);
        when(() => mockDio.get(any(),
            queryParameters: any(named: 'queryParameters'))).thenAnswer(
          (_) async => Response(
            data: jsonMap,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        // act
        final result = await dataSource.fetchInventories(params);

        // assert
        expect(result, isA<List<BatchEntity>>());
      },
    );
  });

  group('fetch inventories count remote data sources test', () {
    test(
      'should return int when the request status code is 200',
      () async {
        // arrange
        final jsonString =
            fixtureReader('data_sources/get_inventories_count.json');
        final jsonMap = jsonDecode(jsonString);
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: jsonMap,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        // act
        final result = await dataSource.fetchInventoriesCount();

        // assert
        expect(result, isA<int>());
      },
    );
  });

  group('fetch on the way shipments remote data sources test', () {
    const params =
        FetchOnTheWayShipmentsUseCaseParams(page: 1, perPage: 10, search: '');
    test(
      'should return List<BatchEntity> when the request status code is 200',
      () async {
        // arrange
        final jsonString =
            fixtureReader('data_sources/get_on_the_way_shipments.json');
        final jsonMap = jsonDecode(jsonString);
        when(() => mockDio.get(any(),
            queryParameters: any(named: 'queryParameters'))).thenAnswer(
          (_) async => Response(
            data: jsonMap,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        // act
        final result = await dataSource.fetchOnTheWayShipments(params);

        // assert
        expect(result, isA<List<BatchEntity>>());
      },
    );
  });

  group('fetch picked up goods remote data sources test', () {
    const params = FetchPickedUpGoodsUseCaseParams(
      page: 1,
      perPage: 10,
      search: '',
    );

    test('should return List<PickedGoodEntity> when request status code is 200',
        () async {
      // arrange
      final jsonString = fixtureReader('data_sources/get_picked_up_goods.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.fetchPickedUpGoods(params);

      // assert
      expect(result, isA<List<PickedGoodEntity>>());
      expect(result, isNot(isA<List<PickedGoodModel>>()));
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenThrow(
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
      final result = dataSource.fetchPickedUpGoods(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.fetchPickedUpGoods(params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('fetch prepare shipments remote data sources test', () {
    const params =
        FetchPrepareShipmentsUseCaseParams(page: 1, perPage: 10, search: '');
    test(
      'should return List<BatchEntity> when the request status code is 200',
      () async {
        // arrange
        final jsonString =
            fixtureReader('data_sources/get_prepare_shipments.json');
        final jsonMap = jsonDecode(jsonString);
        when(() => mockDio.get(any(),
            queryParameters: any(named: 'queryParameters'))).thenAnswer(
          (_) async => Response(
            data: jsonMap,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        // act
        final result = await dataSource.fetchPrepareShipments(params);

        // assert
        expect(result, isA<List<BatchEntity>>());
      },
    );
  });

  group('fetch preview delivery shipments remote data sources test', () {
    const params = FetchPreviewDeliveryShipmentsUseCaseParams(
      nextWarehouse: DropdownEntity(
        id: '019903c3-ca71-713d-90a0-549aaea7e2d3',
        value: 'Gudang Tegal',
      ),
      uniqueCodes: ['A00000001760'],
    );

    test('should return List<BatchEntity> when request status code is 200',
        () async {
      // arrange
      final jsonString =
          fixtureReader('data_sources/get_preview_delivery_shipments.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.fetchPreviewDeliveryShipments(params);

      // assert
      expect(result, isA<List<BatchEntity>>());
      expect(result, isNot(isA<List<BatchModel>>()));
      verify(() => mockDio.post(any(), data: {
            'next_warehouse_id': params.nextWarehouse.id,
            // 'driver_id': params.driver?.id,
            'codes': params.uniqueCodes,
          })).called(1);
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
      final result = dataSource.fetchPreviewDeliveryShipments(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.fetchPreviewDeliveryShipments(params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('fetch preview pick up goods remote data sources test', () {
    const params = ['A00000002442', 'A00000002442'];

    test('should return List<GoodEntity> when request status code is 200',
        () async {
      // arrange
      final jsonString =
          fixtureReader('data_sources/get_preview_pick_up_goods.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.fetchPreviewPickUpGoods(params);

      // assert
      expect(result, isA<List<GoodEntity>>());
      expect(result, isNot(isA<List<GoodModel>>()));
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
      final result = dataSource.fetchPreviewPickUpGoods(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(Exception('Unexpected error occurs'));

      // act
      final result = dataSource.fetchPreviewPickUpGoods(params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('fetch preview prepare shipments remote data sources test', () {
    const params = ['A00000000787', 'A00000000788', 'A00000000789'];

    test('should return List<GoodEntity> when request status code is 200',
        () async {
      // arrange
      final jsonString = fixtureReader('data_sources/get_prepare_batch.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.fetchPreviewPrepareShipments(params);

      // assert
      expect(result, isA<List<GoodEntity>>());
      expect(result, isNot(isA<List<GoodModel>>()));
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
      final result = dataSource.fetchPreviewPrepareShipments(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(const InternalException());

      // act
      final result = dataSource.fetchPreviewPrepareShipments(params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('fetch preview receive shipments remote data sources test', () {
    const params = FetchPreviewReceiveShipmentsUseCaseParams(
      origin: DropdownEntity(id: 'id', value: 'value'),
      uniqueCodes: [
        'A00000000787',
        'A00000000788',
        'A00000000789',
        'A00000000790',
        'A00000000791'
      ],
    );
    test(
      'should return int when the request status code is 200',
      () async {
        // arrange
        final jsonString =
            fixtureReader('data_sources/get_shipments_from_codes.json');
        final jsonMap = jsonDecode(jsonString);
        when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: jsonMap,
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        // act
        final result = await dataSource.fetchPreviewReceiveShipments(params);

        // assert
        expect(result, isA<List<BatchEntity>>());
        verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);
      },
    );
  });

  group('create picked up goods remote data sources test', () {
    setUp(() => File('lorem.txt').writeAsBytesSync([1, 2, 3]));

    tearDown(File('lorem.txt').deleteSync);

    final params = CreatePickedUpGoodsUseCaseParams(
        receiptNumbers: [],
        uniqueCodes: [],
        note: 'note',
        imagePath: 'lorem.txt',
        pickedUpAt: DateTime.now());

    test('should return String when request status code is 200', () async {
      // arrange
      final jsonString =
          fixtureReader('data_sources/create_picked_up_goods.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.createPickedUpGoods(params);

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
      final result = dataSource.createPickedUpGoods(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenThrow(Exception('Unexpected error happen'));

      // act
      final result = dataSource.createPickedUpGoods(params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });

  group('fetch good timeline remote data sources test', () {
    const params = 'receipt_number';

    test('should return TimelineSummaryEntity when request status code is 200',
        () async {
      // arrange
      final jsonString = fixtureReader('data_sources/get_timeline.json');
      final json = jsonDecode(jsonString);
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: json,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.fetchGoodTimeline(params);

      // assert
      expect(result, isA<TimelineSummaryEntity>());
      expect(result, isNot(isA<TimelineSummaryModel>()));
    });

    test('should throw ServerException when request status code is not 200',
        () async {
      // arrange
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenThrow(
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
      final result = dataSource.fetchGoodTimeline(params);

      // assert
      await expectLater(result, throwsA(isA<ServerException>()));
    });

    test('should throw InternalException when an unexpected error occurs',
        () async {
      // arrange
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(Exception('Unexpected error happen'));

      // act
      final result = dataSource.fetchGoodTimeline(params);

      // assert
      await expectLater(result, throwsA(isA<InternalException>()));
    });
  });
}
