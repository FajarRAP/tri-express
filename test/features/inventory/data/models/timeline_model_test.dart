import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/timeline_model.dart';
import 'package:tri_express/features/inventory/domain/entities/timeline_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('Timeline model test', () {
    final tTimelineModel = TimelineModel(
      address: 'Jl. Example No.123, Jakarta',
      description: 'Package received at the warehouse',
      dateTime: DateTime.parse('2023-10-01T10:30:00Z'),
    );

    test('should be a subclass of TimelineEntity', () {
      expect(tTimelineModel, isA<TimelineEntity>());
    });

    test('should not bring implementation details', () {
      expect(tTimelineModel.toEntity(), isA<TimelineEntity>());
      expect(tTimelineModel.toEntity(), isNot(isA<TimelineModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/timeline.json');
      final json = jsonDecode(jsonString);

      // act
      final result = TimelineModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<TimelineEntity>());
    });
  });
}
