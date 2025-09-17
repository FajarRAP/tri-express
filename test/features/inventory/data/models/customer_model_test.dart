import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/customer_model.dart';
import 'package:tri_express/features/inventory/domain/entities/customer_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tCustomerModel = CustomerModel(
    id: 'id',
    code: 'code',
    address: 'address',
    name: 'name',
    phoneNumber: 'phoneNumber',
  );

  test('should be a subclass of customer entity', () {
    expect(tCustomerModel, isA<CustomerEntity>());
  });

  test('should be not bring implementation details', () {
    expect(tCustomerModel.toEntity(), isA<CustomerEntity>());
  });

  test('should return a valid model from JSON', () {
    // arrange
    final jsonString = fixtureReader('models/customer.json');
    final json = jsonDecode(jsonString);

    // act
    final model = CustomerModel.fromJson(json);

    // assert
    expect(model, isA<CustomerModel>());
  });
}