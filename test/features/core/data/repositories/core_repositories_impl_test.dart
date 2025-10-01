import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/cache_exception.dart';
import 'package:tri_express/core/failure/failure.dart';
import 'package:tri_express/features/core/data/data_sources/core_local_data_source.dart';
import 'package:tri_express/features/core/data/data_sources/core_remote_data_source.dart';
import 'package:tri_express/features/core/data/repositories/core_repository_impl.dart';

class MockCoreLocalDataSource extends Mock implements CoreLocalDataSource {}

class MockCoreRemoteDataSource extends Mock implements CoreRemoteDataSource {}

void main() {
  late MockCoreLocalDataSource mockAuthLocalDataSource;
  late MockCoreRemoteDataSource mockAuthRemoteDataSource;
  late CoreRepositoryImpl coreRepository;

  setUp(() {
    mockAuthLocalDataSource = MockCoreLocalDataSource();
    mockAuthRemoteDataSource = MockCoreRemoteDataSource();
    coreRepository = CoreRepositoryImpl(
      coreLocalDataSource: mockAuthLocalDataSource,
      coreRemoteDataSource: mockAuthRemoteDataSource,
    );
  });

  group(
    'complete onboarding: ',
    () {
      test(
        'should call returnOnboarding with correct key when completeOnboarding is called',
        () async {
          // arrange
          when(() => mockAuthLocalDataSource.completeOnboarding())
              .thenAnswer((_) async => {});

          // act
          final result = await coreRepository.completeOnboarding();

          // assert
          await expectLater(result, const Right(null));
          verify(() => mockAuthLocalDataSource.completeOnboarding()).called(1);
        },
      );

      test(
        'should return CacheFailure when failed to write to storage',
        () async {
          // arrange
          when(() => mockAuthLocalDataSource.completeOnboarding())
              .thenThrow(const CacheException());

          // act
          final result = await coreRepository.completeOnboarding();

          // assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<CacheFailure>()),
            (success) => fail('Expected Left, but got Right'),
          );
        },
      );
    },
  );
}
