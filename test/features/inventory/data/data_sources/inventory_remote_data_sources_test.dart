import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/features/inventory/data/data_sources/inventory_remote_data_sources.dart';
import 'package:tri_express/features/inventory/domain/entities/batch_entity.dart';
import 'package:tri_express/features/inventory/domain/use_cases/fetch_delivery_shipments_use_case.dart';

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
    'fetch delivery Shipments',
    () {
      const params = FetchDeliveryShipmentsUseCaseParams(page: 1, perPage: 10);
      test(
        'should return List<BatchEntity> when the request status code is 200',
        () async {
          // arrange
          final jsonString =
              fixtureReader('data_sources/get_delivery_Shipments.json');
          final jsonMap = jsonDecode(jsonString);
          when(() => mockDio.get(any())).thenAnswer(
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
}
