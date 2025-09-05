import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/exceptions/cache_exception.dart';
import 'package:tri_express/core/failure/failure.dart';
import 'package:tri_express/features/core/data/data_sources/core_local_data_sources.dart';
import 'package:tri_express/features/core/data/data_sources/core_remote_data_sources.dart';
import 'package:tri_express/features/core/data/repositories/core_repositories_impl.dart';

class MockCoreLocalDataSources extends Mock implements CoreLocalDataSources {}

class MockCoreRemoteDataSources extends Mock implements CoreRemoteDataSources {}

void main() {
  late MockCoreLocalDataSources mockAuthLocalDataSources;
  late MockCoreRemoteDataSources mockAuthRemoteDataSources;
  late CoreRepositoriesImpl coreRepositories;

  setUp(() {
    mockAuthLocalDataSources = MockCoreLocalDataSources();
    mockAuthRemoteDataSources = MockCoreRemoteDataSources();
    coreRepositories = CoreRepositoriesImpl(
      coreLocalDataSources: mockAuthLocalDataSources,
      coreRemoteDataSources: mockAuthRemoteDataSources,
    );
  });

  group(
    'complete onboarding: ',
    () {
      test(
        'should call returnOnboarding with correct key when completeOnboarding is called',
        () async {
          // arrange
          when(() => mockAuthLocalDataSources.completeOnboarding())
              .thenAnswer((_) async => {});

          // act
          final result = await coreRepositories.completeOnboarding();

          // assert
          await expectLater(result, Right(null));
          verify(() => mockAuthLocalDataSources.completeOnboarding()).called(1);
        },
      );

      test(
        'should return CacheFailure when failed to write to storage',
        () async {
          // arrange
          when(() => mockAuthLocalDataSources.completeOnboarding())
              .thenThrow(CacheException());

          // act
          final result = await coreRepositories.completeOnboarding();

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
