import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_sql_record.dart';

void main() {
  group('FieldData cancel', () { 
    test('sets value to initial without updates', () async {
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
        fieldData.cancel();
        expect(fieldData.controller.text, initialValue);
      }
    });
    test('sets value to initial after some updates', () async {
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
        // fieldData.update('updateValue1');
        // fieldData.update('updateValue2');
        // fieldData.update('updateValue3');
        // fieldData.cancel();
        // expect(fieldData.value, initialValue);
        fieldData.controller.text = 'updateValue1';
        fieldData.controller.text = 'updateValue2';
        fieldData.controller.text = 'updateValue3';
        fieldData.cancel();
        expect(fieldData.controller.text, initialValue);
      }
    });
  });
}