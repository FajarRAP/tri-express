import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/batch_model.dart';
import 'package:tri_express/features/inventory/data/models/warehouse_model.dart';
import 'package:tri_express/features/inventory/domain/entities/batch_entity.dart';

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
      updatedAt: DateTime.now());

  final tBatchModel = BatchModel(
      id: 'id',
      name: 'name',
      status: 'status',
      transportMode: 'mode',
      trackingNumber: 'trackingNumber',
      goods: [],
      origin: tWarehouseModel,
      destination: tWarehouseModel,
      sendAt: DateTime.now());

  test(
    'should be a subclass of batch entity',
    () {
      expect(tBatchModel, isA<BatchEntity>());
    },
  );

  test(
    'should be not bring implementation details',
    () {
      expect(tBatchModel.toEntity(), isA<BatchEntity>());
    },
  );

  test(
    'should return a valid model from JSON',
    () {
      // arrange
      final jsonString = fixtureReader('models/batch.json');
      final jsonMap = jsonDecode(jsonString);

      // act
      final model = BatchModel.fromJson(jsonMap);

      // assert
      expect(model, isA<BatchModel>());
    },
  );
}
