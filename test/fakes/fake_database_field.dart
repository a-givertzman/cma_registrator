import 'package:cma_registrator/core/models/persistable/database_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

class FakeDatabaseField extends Fake implements DatabaseField {
  final ResultF<String>? saveResult;
  final ResultF<String>? fetchResult;
  FakeDatabaseField({this.saveResult, this.fetchResult});
  @override
  Future<ResultF<String>> persist(String value) => Future.value(saveResult);
  @override
  Future<ResultF<String>> fetch() => Future.value(fetchResult);
}