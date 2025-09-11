import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/inventory/data/models/good_model.dart';
import 'package:tri_express/features/inventory/domain/entities/good_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tGoodModel = GoodModel(
    id: 'id',
    name: 'name',
    receiptNumber: 'receiptNumber',
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
