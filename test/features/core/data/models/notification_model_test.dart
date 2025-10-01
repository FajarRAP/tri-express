import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/core/data/models/notification_model.dart';
import 'package:tri_express/features/core/domain/entities/notification_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNotificationModel = NotificationModel(
    title: 'title',
    message: 'message',
  );

  group('notification model test', () {
    test('should be a subclass of NotificationEntity', () {
      expect(tNotificationModel, isA<NotificationEntity>());
    });

    test('should not bring implementation details', () {
      expect(tNotificationModel.toEntity(), isA<NotificationEntity>());
      expect(tNotificationModel.toEntity(), isNot(isA<NotificationModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/notification.json');
      final json = jsonDecode(jsonString);

      // act
      final result = NotificationModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<NotificationEntity>());
    });
  });
}
