import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/features/core/data/data_sources/core_remote_data_sources.dart';
import 'package:tri_express/features/core/data/models/dropdown_model.dart';
import 'package:tri_express/features/core/domain/entities/dropdown_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late CoreRemoteDataSourcesImpl dataSources;

  setUp(() {
    mockDio = MockDio();
    dataSources = CoreRemoteDataSourcesImpl(dio: mockDio);
  });

  group(
    'fetch banners remote data source',
    () {
      test(
        'should return List<String> when request is successful',
        () async {
          // arrange
          const json = <String, dynamic>{
            "status": "Success",
            "message": "data summary",
            "data": [
              {
                "id": "01991817-f390-72c0-b2bf-bbb8dd108cf2",
                "title": "Night Landscape",
                "foto": "banner/VtNM9FxD94U7zd0zRqS79mVFMFDUmsrJSK7kBMC9.jpg",
                "status": 1,
                "created_at": "2025-09-05T04:17:26.000000Z",
                "updated_at": "2025-09-05T04:17:46.000000Z",
                "foto_url":
                    "http://159.65.13.17/storage/banner/VtNM9FxD94U7zd0zRqS79mVFMFDUmsrJSK7kBMC9.jpg"
              }
            ]
          };
          when(() => mockDio.get(any())).thenAnswer((_) async => Response(
              data: json, requestOptions: RequestOptions(), statusCode: 200));

          // act
          final result = await dataSources.fetchBanners();

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
            "status": "Success",
            "message": "data summary",
            "data": {"ontheway": 0, "diterima": 0, "dikirim": 0}
          };
          when(() => mockDio.get(any())).thenAnswer((_) async => Response(
              data: json, requestOptions: RequestOptions(), statusCode: 200));

          // act
          final result = await dataSources.fetchSummary();

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
          final result = await dataSources.fetchTransportModeDropdown();

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
          final result = await dataSources.fetchWarehouseDropdown();

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
          final result = await dataSources.fetchDriverDropdown();

          // assert
          expect(result, isNot(isA<List<DropdownModel>>()));
          expect(result, isA<List<DropdownEntity>>());
        },
      );
    },
  );
}
