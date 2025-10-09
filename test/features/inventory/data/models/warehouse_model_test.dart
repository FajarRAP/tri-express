import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/warehouse_model.dart';
import 'package:tri_express/features/inventory/domain/entities/warehouse_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tWarehouseModel = WarehouseModel(
    id: '019903c3-ca54-7183-96d2-381bce035072',
    countryId: '019903c3-c9e1-73f2-9a60-1054fa4a55a4',
    address: 'Jr. Krakatau No. 972',
    description: 'Eligendi eos quis reiciendis eum est.',
    latitude: '-9.319892',
    longitude: '126.409562',
    name: 'Gudang Pekalongan',
    phone: '(+62) 758 8958 1894',
    warehouseCode: 'MHUO',
    createdAt: DateTime.parse('2025-09-01T05:33:07.000000Z'),
    updatedAt: DateTime.parse('2025-09-01T05:33:07.000000Z'),
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
      expect(model, tWarehouseModel);
    },
  );
}
