import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/models/field/field_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
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
          saveResult: const Result(data: successData),
        ),
      );
      final fetchResult = await fieldData.save();
      expect(fetchResult.hasData, isTrue);
      expect(fetchResult.hasError, isFalse);
      expect(fetchResult.data, equals(successData));
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
          saveResult: Result(error: failure),
        ),
      );
      final fetchResult = await fieldData.save();
      expect(fetchResult.hasData, isFalse);
      expect(fetchResult.hasError, isTrue);
      expect(fetchResult.error.message, equals(failure.message));
    });
  });
}