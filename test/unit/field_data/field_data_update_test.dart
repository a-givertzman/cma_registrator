import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_sql_record.dart';

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
        label: 'test', 
        initialValue: 'initialValue', 
        record: FakeSqlRecord(),
      );
      for (final newValue in updateData) {
        fieldData.update(newValue);
        expect(fieldData.value, newValue);
      }
    });
  });
}