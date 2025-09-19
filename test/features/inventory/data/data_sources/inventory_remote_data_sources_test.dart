import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/features/inventory/data/data_sources/inventory_remote_data_sources.dart';
import 'package:tri_express/features/inventory/domain/entities/batch_entity.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_delivery_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_inventories_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_prepare_shipments_use_case.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_preview_receive_shipments_use_case.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late InventoryRemoteDataSourcesImpl inventoryRemoteDataSources;

  setUp(() {
    mockDio = MockDio();
    inventoryRemoteDataSources = InventoryRemoteDataSourcesImpl(dio: mockDio);
  });

  group(
    'fetch delivery shipments remote data sources test',
    () {
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
          final result = await inventoryRemoteDataSources
              .fetchDeliveryShipments(params: params);

          // assert
          expect(result, isA<List<BatchEntity>>());
        },
      );
    },
  );

  group(
    'fetch on the way shipments remote data sources test',
    () {
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
          final result = await inventoryRemoteDataSources
              .fetchOnTheWayShipments(params: params);

          // assert
          expect(result, isA<List<BatchEntity>>());
        },
      );
    },
  );

  group(
    'fetch inventories remote data sources test',
    () {
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
          final result =
              await inventoryRemoteDataSources.fetchInventories(params: params);

          // assert
          expect(result, isA<List<BatchEntity>>());
        },
      );
    },
  );

  group(
    'fetch prepare shipments remote data sources test',
    () {
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
          final result = await inventoryRemoteDataSources.fetchPrepareShipments(
              params: params);

          // assert
          expect(result, isA<List<BatchEntity>>());
        },
      );
    },
  );

  group(
    'fetch inventories count remote data sources test',
    () {
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
          final result =
              await inventoryRemoteDataSources.fetchInventoriesCount();

          // assert
          expect(result, isA<int>());
        },
      );
    },
  );

  group(
    'fetch preview receive shipments remote data sources test',
    () {
      const params = FetchPreviewReceiveShipmentsUseCaseParams(
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
          final result = await inventoryRemoteDataSources
              .fetchPreviewReceiveShipments(params: params);

          // assert
          expect(result, isA<List<BatchEntity>>());
          verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);
        },
      );
    },
  );
}
