import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/cache_exception.dart';
import 'package:tri_express/core/utils/constants.dart';
import 'package:tri_express/features/auth/data/data_sources/auth_local_data_sources.dart';

class MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockStorage mockStorage;
  late AuthLocalDataSourcesImpl dataSources;

  const tAccessToken = 'access_token';
  const tRefreshToken = 'refresh_token';

  setUp(() {
    mockStorage = MockStorage();
    dataSources = AuthLocalDataSourcesImpl(storage: mockStorage);
  });

  group(
    'cache token: ',
    () {
      test(
          'should call storage.write with correct keys and values when cacheToken is called',
          () async {
        // arrange
        when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'))).thenAnswer((_) async {});

        // act
        await dataSources.cacheToken(
            accessToken: tAccessToken, refreshToken: tRefreshToken);

        // assert
        verify(() =>
                mockStorage.write(key: accessTokenKey, value: tAccessToken))
            .called(1);
        verify(() =>
                mockStorage.write(key: refreshTokenKey, value: tRefreshToken))
            .called(1);
      });

      test(
        'should return CacheException when cache token fails',
        () async {
          // arrange
          when(() => mockStorage.write(
              key: any(named: 'key'),
              value: any(named: 'value'))).thenThrow(const CacheException());

          // act
          final call = dataSources.cacheToken(
              accessToken: tAccessToken, refreshToken: tRefreshToken);

          // assert
          await expectLater(call, throwsA(isA<CacheException>()));
        },
      );
    },
  );

  group(
    'clear token: ',
    () {
      test(
          'should call storage.delete with correct key when clearToken is called',
          () async {
        // arrange
        when(() => mockStorage.delete(key: any(named: 'key')))
            .thenAnswer((_) async {});

        // act
        await dataSources.clearToken();

        // assert
        verify(() => mockStorage.delete(key: accessTokenKey)).called(1);
        verify(() => mockStorage.delete(key: refreshTokenKey)).called(1);
      });

      test(
        'should return CacheException when clear token fails',
        () async {
          // arrange
          when(() => mockStorage.deleteAll()).thenThrow(const CacheException());

          // act
          final call = dataSources.clearToken();

          // assert
          await expectLater(call, throwsA(isA<CacheException>()));
        },
      );
    },
  );

  group(
    'get access token: ',
    () {
      test(
          'should call storage.read with correct key when getAccessToken is called',
          () async {
        // arrange
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => null);

        // act
        await dataSources.getAccessToken();

        // assert
        verify(() => mockStorage.read(key: accessTokenKey)).called(1);
      });

      test(
          'should return String? with correct key when getAccessToken is called',
          () async {
        // arrange
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => tAccessToken);

        // act
        final result = await dataSources.getAccessToken();

        // assert
        expect(tAccessToken, result);
      });

      test(
        'should return CacheException when get access token fails',
        () async {
          // arrange
          when(() => mockStorage.read(key: any(named: 'key')))
              .thenThrow(const CacheException());

          // act
          final call = dataSources.getAccessToken();

          // assert
          await expectLater(call, throwsA(isA<CacheException>()));
        },
      );
    },
  );

  group(
    'get refresh access token: ',
    () {
      test(
          'should call storage.read with correct key when getRefreshToken is called',
          () async {
        // arrange
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => null);

        // act
        await dataSources.getRefreshToken();

        // assert
        verify(() => mockStorage.read(key: refreshTokenKey)).called(1);
      });

      test(
          'should return String? with correct key when getRefreshToken is called',
          () async {
        // arrange
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => tRefreshToken);

        // act
        final result = await dataSources.getRefreshToken();

        // assert
        expect(tRefreshToken, result);
      });

      test(
        'should return CacheException when get refresh token fails',
        () async {
          // arrange
          when(() => mockStorage.read(key: any(named: 'key')))
              .thenThrow(const CacheException());

          // act
          final call = dataSources.getRefreshToken();

          // assert
          await expectLater(call, throwsA(isA<CacheException>()));
        },
      );
    },
  );
}
