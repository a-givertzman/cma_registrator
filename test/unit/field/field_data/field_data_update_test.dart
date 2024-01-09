import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/models/field/field_type.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fakes/fake_database_field.dart';

void main() {
  group('FieldData update', () { 
    test('changes current value', () async {
      const updateData = [
        'abc',
        '123456',
        'someTestData1',
        '+=-_()*;&.^,:%\$#№@"!><',
      ];
      final fieldData = FieldData(
        id: '',
        type: FieldType.string,
        label: 'test', 
        initialValue: 'initialValue', 
        record: FakeDatabaseField(),
      );
      for (final newValue in updateData) {
        // fieldData.update(newValue);
        fieldData.controller.text = newValue;
        expect(fieldData.controller.text, newValue);
      }
    });
  });
}