import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/core/data/models/notification_model.dart';
import 'package:tri_express/features/core/domain/entities/notification_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNotificationModel = NotificationModel(
    title: 'Pengiriman menuju gudangmu Gudang Palopo',
    message:
        'Barang dengan No Pengiriman #SHIP.2509241458249 dari Gudang Pekalongan via jalur Udara sedang dalam perjalanan ke gudangmu (5 koli).',
    createdAt: DateTime.parse('2025-09-24T08:01:06.000000Z'),
    readAt: null,
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
      expect(result.toEntity(), tNotificationModel.toEntity());
    });
  });
}
