import 'package:cma_registrator/core/models/field/field_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FieldType.from() creates right enum members from string', 
    () {
      final fieldTypesMapping = {
        'date': FieldType.date,
        'int': FieldType.int,
        'real': FieldType.real,
        'string': FieldType.string,
      };
      for(final entry in fieldTypesMapping.entries) {
        final serializedFieldType = entry.key;
        final deserializedFieldType = entry.value;
        expect(FieldType.from(serializedFieldType), deserializedFieldType);
      }
    },
  );
}