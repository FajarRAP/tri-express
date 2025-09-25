import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/customer_model.dart';
import 'package:tri_express/features/inventory/data/models/picked_good_model.dart';
import 'package:tri_express/features/inventory/data/models/warehouse_model.dart';
import 'package:tri_express/features/inventory/domain/entities/picked_good_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tCustomerModel = CustomerModel(
    id: 'id',
    code: 'code',
    address: 'address',
    name: 'name',
    phoneNumber: 'phoneNumber',
  );
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
  final tPickedGoodModel = PickedGoodModel(
    id: 'id',
    receiptNumber: 'receiptNumber',
    invoiceNumber: 'invoiceNumber',
    name: 'name',
    transportMode: 'transportMode',
    totalItem: 1,
    customer: tCustomerModel,
    origin: tWarehouseModel,
    destination: tWarehouseModel,
    uniqueCodes: [],
    deliveryCode: 'deliveryCode',
    note: 'note',
    photoUrl: 'photoUrl',
    deliveredAt: DateTime.now(),
  );

  group('picked good model test', () {
    test('should be a subclass of PickedGoodEntity', () {
      expect(tPickedGoodModel, isA<PickedGoodEntity>());
    });

    test('should not bring implementation details', () {
      expect(tPickedGoodModel.toEntity(), isA<PickedGoodEntity>());
      expect(tPickedGoodModel.toEntity(), isNot(isA<PickedGoodModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/picked_good.json');
      final json = jsonDecode(jsonString);

      // act
      final result = PickedGoodModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<PickedGoodEntity>());
    });
  });
}
