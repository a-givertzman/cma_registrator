import 'package:cma_registrator/core/models/persistable/sql_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result.dart';

class FakeDatabaseField extends Fake implements DatabaseField {
  final Result<String>? saveResult;
  final Result<String>? fetchResult;
  FakeDatabaseField({this.saveResult, this.fetchResult});
  @override
  Future<Result<String>> persist(String value) => Future.value(saveResult);
  @override
  Future<Result<String>> fetch() => Future.value(fetchResult);
}