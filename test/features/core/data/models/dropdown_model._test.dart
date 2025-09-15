import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/core/data/models/dropdown_model.dart';
import 'package:tri_express/features/core/domain/entities/dropdown_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const DropdownModel tDropdownModel = DropdownModel(
    id: '1',
    value: 'Test Value',
  );
  group(
    'dropdown model test',
    () {
      test(
        'should be subclass of DropdownEntity',
        () => expect(tDropdownModel, isA<DropdownEntity>()),
      );

      test('fromJson should return valid DropdownModel', () {
        final jsonString = fixtureReader('models/dropdown.json');
        final json = jsonDecode(jsonString);

        final result = DropdownModel.fromJson(json);

        expect(result, isA<DropdownModel>());
      });
    },
  );
}
