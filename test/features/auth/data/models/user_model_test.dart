import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/auth/data/models/user_model.dart';
import 'package:tri_express/features/auth/domain/entities/user_entity.dart';
import 'package:tri_express/features/inventory/data/models/warehouse_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    id: '019903c3-cea2-7034-a051-d4d169d78f72',
    warehouseId: '019903c3-ca8b-713f-9037-0ef28cab6905',
    email: 'palopo@domain.com',
    name: 'G_Palopo',
    phoneNumber: '+231486558155',
    roles: ['admin_gudang'],
    warehouse: WarehouseModel(
      id: '019903c3-ca8b-713f-9037-0ef28cab6905',
      countryId: '019903c3-c994-70a8-b5ea-a2e3aa4ddf8c',
      address: 'Ds. Sudirman No. 158',
      description: 'Mollitia et reprehenderit consequatur.',
      latitude: '2.472032',
      longitude: '125.315517',
      name: 'Gudang Palopo',
      phone: '(+62) 943 6595 355',
      warehouseCode: 'QWXR',
      createdAt: DateTime.parse('2025-09-01 05:33:07.000Z'),
      updatedAt: DateTime.parse('2025-09-01 05:33:07.000Z'),
    ),
  );

  group('User model test', () {
    test('should be a subclass of UserEntity', () {
      expect(tUserModel, isA<UserEntity>());
    });

    test('should not bring implementation details', () {
      expect(tUserModel.toEntity(), isA<UserEntity>());
      expect(tUserModel.toEntity(), isNot(isA<UserModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/user.json');
      final json = jsonDecode(jsonString);

      // act
      final result = UserModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<UserEntity>());
    });
  });
}
