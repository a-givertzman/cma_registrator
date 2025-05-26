import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/models/field/field_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import '../../../fakes/fake_database_field.dart';

void main() {
  group('FieldData save', () { 
    test('returns success result on sql record succes', () async {
      const successData = 'successData';
      final fieldData = FieldData(
        id: '',
        type: FieldType.string,
        label: 'test', 
        initialValue: '', 
        record: FakeDatabaseField(
          saveResult: const Ok(successData),
        ),
      );
      final fetchResult = await fieldData.save();
      expect(fetchResult is Ok, isTrue);
      expect(fetchResult is Err, isFalse);
      expect((fetchResult as Ok<String, Failure>).value, equals(successData));
    });
    test('returns error result on sql record error', () async {
      final failure = Failure(
        message: 'message', 
        stackTrace: StackTrace.current,
      );
      final fieldData = FieldData(
        id: '',
        type: FieldType.string,
        label: 'test', 
        initialValue: '', 
        record: FakeDatabaseField(
          saveResult: Err(failure),
        ),
      );
      final fetchResult = await fieldData.save();
      expect(fetchResult is Ok, isFalse);
      expect(fetchResult is Err, isTrue);
      expect((fetchResult as Err<String, Failure>).error.message, equals(failure.message));
    });
  });
}