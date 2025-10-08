import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/customer_model.dart';
import 'package:tri_express/features/inventory/data/models/good_model.dart';
import 'package:tri_express/features/inventory/data/models/warehouse_model.dart';
import 'package:tri_express/features/inventory/domain/entities/good_entity.dart';

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
  final tGoodModel = GoodModel(
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
  );

  test(
    'should be a subclass of good entity',
    () {
      expect(tGoodModel, isA<GoodEntity>());
    },
  );

  test(
    'should be not bring implementation details',
    () {
      expect(tGoodModel.toEntity(), isA<GoodEntity>());
    },
  );

  test(
    'should return a valid model from JSON',
    () {
      // arrange
      final jsonString = fixtureReader('models/good.json');
      final jsonMap = jsonDecode(jsonString);

      // act
      final model = GoodModel.fromJson(jsonMap);

      // assert
      expect(model, isA<GoodModel>());
    },
  );
}
