import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tri_express/core/utils/constants.dart';
import 'package:tri_express/features/core/data/data_sources/core_local_data_source.dart';

class MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockStorage mockStorage;
  late CoreLocalDataSourceImpl dataSource;

  const tOnboardingDone = 'true';

  setUp(() {
    mockStorage = MockStorage();
    dataSource = CoreLocalDataSourceImpl(storage: mockStorage);
  });

  group(
    'complete onboarding:',
    () {
      test(
        'should be call storage.write when completeOnboarding called',
        () async {
          // arrange
          when(() => mockStorage.write(
              key: any(named: 'key'),
              value: any(named: 'value'))).thenAnswer((_) async {});

          // act
          await dataSource.completeOnboarding();

          // assert
          verify(() =>
                  mockStorage.write(key: onboardingKey, value: tOnboardingDone))
              .called(1);
        },
      );
    },
  );
}
