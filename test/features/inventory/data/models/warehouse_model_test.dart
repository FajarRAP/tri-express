import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/warehouse_model.dart';
import 'package:tri_express/features/inventory/domain/entities/warehouse_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tWarehouseModel = WarehouseModel(
    id: 'id',
    countryId: 'countryId',
    address: 'address',
    description: 'description',
    latitude: 'latitude',
    longitude: 'longitude',
    name: 'name',
    phone: 'phone',
    warehouseCode: 'warehouseCode',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  test(
    'should be a subclass of warehouse entity',
    () {
      expect(tWarehouseModel, isA<WarehouseEntity>());
    },
  );

  test(
    'should be not bring implementation details',
    () {
      expect(tWarehouseModel.toEntity(), isA<WarehouseEntity>());
    },
  );

  test(
    'should return a valid model from JSON',
    () {
      // arrange
      final jsonString = fixtureReader('models/warehouse.json');
      final jsonMap = jsonDecode(jsonString);

      // act
      final model = WarehouseModel.fromJson(jsonMap);

      // assert
      expect(model, isA<WarehouseModel>());
    },
  );
}
