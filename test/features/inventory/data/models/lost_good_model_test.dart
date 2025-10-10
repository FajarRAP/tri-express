import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/lost_good_model.dart';
import 'package:tri_express/features/inventory/domain/entities/customer_entity.dart';
import 'package:tri_express/features/inventory/domain/entities/lost_good_entity.dart';
import 'package:tri_express/features/inventory/domain/entities/warehouse_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tCustomerModel = CustomerEntity(
    id: '019999f1-db0a-70ee-bf20-e21b7c50a650',
    code: '003',
    address: 'jalan merdeka 78',
    name: 'IBRE',
    phoneNumber: '222',
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
  final tCurrent = WarehouseEntity(
    id: '019999cd-0835-73e7-a396-4f70d9d6f317',
    countryId: '019999c7-3def-70df-8c6d-4a53dae4682a',
    address: 'jalan bandeng 6',
    description: '23423',
    latitude: '-6.173421305040958',
    longitude: '106.82708242921241',
    name: 'Transit1',
    phone: '0938490',
    warehouseCode: 'TR1',
    createdAt: DateTime.parse('2025-09-30T08:46:15.000000Z'),
    updatedAt: DateTime.parse('2025-09-30T08:46:15.000000Z'),
  );

  final tLostGoodModel = LostGoodModel(
    id: '298',
    receiptNumber: 'TRI.251006152939928',
    invoiceNumber: 'INV.251001123851376',
    name: 'Bag/Beta',
    statusLabel: 'Tiba di Gudang Tujuan',
    status: 3,
    transportMode: 'Laut',
    totalItem: 0,
    customer: tCustomerModel,
    origin: tOrigin,
    destination: tDestination,
    allUniqueCodes: ['A00000000707','A00000000708','A00000000709'],
    uniqueCodes: [],
    currentWarehouse: tCurrent,
    issuedAt: DateTime.parse('2025-09-30T17:00:00.000000Z'),
  );

  group('lost good model test', () {
    test('should be a subclass of LostGoodEntity', () {
      expect(tLostGoodModel, isA<LostGoodEntity>());
    });
  
    test('should not bring implementation details', () {
      expect(tLostGoodModel.toEntity(), isA<LostGoodEntity>());
      expect(tLostGoodModel.toEntity(), isNot(isA<LostGoodModel>()));
    });
  
    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/lost_good.json');
      final json = jsonDecode(jsonString);
  
      // act
      final result = LostGoodModel.fromJson(json);
  
      // assert
      expect(result.toEntity(), tLostGoodModel.toEntity());
    });
  });
}
