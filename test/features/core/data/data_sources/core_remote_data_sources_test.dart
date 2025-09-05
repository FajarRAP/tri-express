import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/features/core/data/data_sources/core_remote_data_sources.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late CoreRemoteDataSourcesImpl dataSources;

  setUp(() {
    mockDio = MockDio();
    dataSources = CoreRemoteDataSourcesImpl(dio: mockDio);
  });

  group(
    'fetch banners: ',
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
}
