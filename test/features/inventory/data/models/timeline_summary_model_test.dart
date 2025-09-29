import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/timeline_summary_model.dart';
import 'package:tri_express/features/inventory/domain/entities/timeline_summary_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tTimelineSummaryModel = TimelineSummaryModel(
    status: 1,
    statusLabel: 'In Transit',
    timelines: [],
  );
  group('timeline summary model test', () {
    test('should be a subclass of TimelineSummaryEntity', () {
      expect(tTimelineSummaryModel, isA<TimelineSummaryEntity>());
    });

    test('should not bring implementation details', () {
      expect(tTimelineSummaryModel.toEntity(), isA<TimelineSummaryEntity>());
      expect(
          tTimelineSummaryModel.toEntity(), isNot(isA<TimelineSummaryModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/timeline_summary.json');
      final json = jsonDecode(jsonString);

      // act
      final result = TimelineSummaryModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<TimelineSummaryEntity>());
    });
  });
}
