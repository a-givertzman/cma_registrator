import 'package:cma_registrator/core/models/persistable/sql_record.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result.dart';

class FakeSqlRecord extends Fake implements SqlRecord {
  final Result<String>? saveResult;
  final Result<String>? fetchResult;
  FakeSqlRecord({this.saveResult, this.fetchResult});
  @override
  Future<Result<String>> persist(String value) => Future.value(saveResult);
  @override
  Future<Result<String>> fetch() => Future.value(fetchResult);
}