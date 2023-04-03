import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_sql_record.dart';

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
          label: 'test', 
          initialValue: initialValue, 
          record: FakeSqlRecord(),
        );
        expect(fieldData.value, initialValue);

      }
    });
  });
}