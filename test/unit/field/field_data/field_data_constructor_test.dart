import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/models/field/field_type.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fakes/fake_database_field.dart';

void main() {
  group('FieldData constructor', () { 
    test('sets initialValue to current value', () async {
      const initialData = [
        'abc',
        '123456',
        'someTestData1',
        '+=-_()*;&.^,:%\$#№@"!><',
      ];
      for (final initialValue in initialData) {
        final fieldData = FieldData(
          id: '',
          type: FieldType.string,
          label: 'test', 
          initialValue: initialValue, 
          record: FakeDatabaseField(),
        );
        expect(fieldData.controller.text, initialValue);

      }
    });
  });
}