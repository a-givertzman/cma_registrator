import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class DatabaseField {
  static final _log = const Log('SqlRecord')..level=LogLevel.debug;
  final String _id;
  final String _tableName;
  final String _dbName;
  final ApiAddress _apiAddress;
  /// 
  const DatabaseField({
    required String id,
    required String tableName,
    required String dbName,
    required ApiAddress apiAddress,
  }) : 
    _id = id,
    _tableName = tableName,
    _dbName = dbName, 
    _apiAddress = apiAddress;
  ///
  Future<ResultF<String>> persist(String value) {
    _log.debug('[SqlField.persist] Persisting value \'$value\' for field with id \'$_id\'...');
    return ApiRequest(
      address: _apiAddress,
      authToken: '',
      query: SqlQuery(
        database: _dbName, 
        sql: 'UPDATE $_tableName SET value = \'$value\' WHERE id = \'$_id\';',
      ),
    ).fetch()
    .then<ResultF<String>>((result) => switch(result) {
      Ok(value:final reply) => Ok(reply.toString()),
      Err(:final error) => Err(error),
    })
    .onError((error, stackTrace) => Err(
      Failure(
        message: error.toString(),
        stackTrace: stackTrace,
      ),
    ));
  }
  ///
  Future<ResultF<String>> fetch() {
    _log.debug('[SqlField.fetch] Fetching value for field with id \'$_id\'...');
    return ApiRequest(
      address: _apiAddress, 
      authToken: '',
      query: SqlQuery(
        database: _dbName, 
        sql: 'SELECT value FROM $_tableName WHERE id = \'$_id\' LIMIT 1;',
      ),
    ).fetch()
    .then<ResultF<String>>((result) => switch(result) {
      Ok(value:final reply) => Ok(reply.data.first['value'] as String),
      Err(:final error) => Err(error),
    })
    .onError((error, stackTrace) => Err(
      Failure(
        message: error.toString(),
        stackTrace: stackTrace,
      ),
    ));
  }
}