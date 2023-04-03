import 'dart:math';
import 'package:hmi_core/hmi_core.dart';
class SqlRecord {
  static final _log = const Log('SqlRecord')..level=LogLevel.debug;
  final String _dbFieldName;
  /// 
  const SqlRecord(String dbFieldName) : 
    _dbFieldName = dbFieldName;
  //
  // TODO to be implemented with backend
  Future<Result<String>> persist(String value) async {
    await Future.delayed(const Duration(seconds: 3));
    final random = Random();
    if (random.nextDouble() <= 0.75) {
      _log.debug('Persisted $_dbFieldName: $value');
      return Future.value(Result(data: value));
    }
    return Future.value(
      Result(
        error: Failure(
          message: 'Something went wrong', 
          stackTrace: StackTrace.current,
        ),
      ),
    );
  }
  //
  // TODO to be implemented with backend
  Future<Result<String>> fetch() async {
    await Future.delayed(const Duration(seconds: 3));
    final random = Random();
    const value = 'asd';
    if (random.nextDouble() <= 0.75) {
      _log.debug('Fetched $_dbFieldName with value: $value');
      return Future.value(const Result(data: value));
    }
    return Future.value(
      Result(
        error: Failure(
          message: 'Something went wrong', 
          stackTrace: StackTrace.current,
        ),
      ),
    );
  }
}