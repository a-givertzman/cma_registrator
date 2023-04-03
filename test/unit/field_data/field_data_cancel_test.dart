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
          label: 'test', 
          initialValue: initialValue, 
          record: FakeSqlRecord(),
        );
        fieldData.cancel();
        expect(fieldData.value, initialValue);
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
          label: 'test', 
          initialValue: initialValue, 
          record: FakeSqlRecord(),
        );
        fieldData.update('updateValue1');
        fieldData.update('updateValue2');
        fieldData.update('updateValue3');
        fieldData.cancel();
        expect(fieldData.value, initialValue);
      }
    });
  });
}