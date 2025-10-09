import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/good_model.dart';
import 'package:tri_express/features/inventory/domain/entities/customer_entity.dart';
import 'package:tri_express/features/inventory/domain/entities/good_entity.dart';
import 'package:tri_express/features/inventory/domain/entities/warehouse_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tCustomerModel = CustomerEntity(
    id: '019999ee-f9de-73c8-b52c-d442506a6c0a',
    code: '001',
    address: 'jalan tempura 3',
    name: 'AUGUS',
    phoneNumber: '08672187',
  );
  final tOrigin = WarehouseEntity(
    id: '019999c9-e7bd-707e-b365-b306855dfaef',
    countryId: '019999c7-3def-70df-8c6d-4a53dae4682a',
    address: 'jalan lele7',
    description: 'G_thailand',
    latitude: '-6.173421305040958',
    longitude: '106.82708242921241',
    name: 'thailand',
    phone: '09890',
    warehouseCode: 'THA',
    createdAt: DateTime.parse('2025-09-30T08:42:50.000000Z'),
    updatedAt: DateTime.parse('2025-09-30T08:42:50.000000Z'),
  );
  final tDestination = WarehouseEntity(
    id: '019999ce-4a4d-711b-a89a-8c008148b4e9',
    countryId: '019999c7-be1d-70c3-b8ab-7ecc01621581',
    address: 'jalan medan jaya 6',
    description: 'G_medan',
    latitude: '-6.173421305040958',
    longitude: '106.82708242921241',
    name: 'medan',
    phone: '624308347',
    warehouseCode: 'MDN',
    createdAt: DateTime.parse('2025-09-30T08:47:37.000000Z'),
    updatedAt: DateTime.parse('2025-09-30T08:47:37.000000Z'),
  );
  final tGoodModel = GoodModel(
    id: '272',
    receiptNumber: 'TRI.251007121308705',
    invoiceNumber: 'INV.251001123316105',
    name: 'CTN/Prime',
    statusLabel: 'Tiba di Gudang Tujuan',
    transportMode: 'Laut',
    status: 3,
    totalItem: 1,
    customer: tCustomerModel,
    origin: tOrigin,
    destination: tDestination,
    allUniqueCodes: [],
    uniqueCodes: ['A00000000640'],
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
      expect(model, tGoodModel);
    },
  );
}
