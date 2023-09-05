import 'package:dart_api_client/dart_api_client.dart';
import 'package:hmi_core/hmi_core.dart';
///
class SqlField {
  static final _log = const Log('SqlRecord')..level=LogLevel.debug;
  final String _fieldName;
  final String _tableName;
  final String _dbName;
  final ApiAddress _apiAddress;
  /// 
  const SqlField({
    required String fieldName,
    required String tableName,
    required String dbName,
    required ApiAddress apiAddress,
  }) : 
    _fieldName = fieldName,
    _tableName = tableName,
    _dbName = dbName, 
    _apiAddress = apiAddress;
  ///
  Future<Result<String>> persist(String value) {
    _log.debug('[SqlField.persist] Persisting value \'$value\' for field \'$_fieldName\'...');
    return ApiRequest(
      address: _apiAddress,
      sqlQuery: SqlQuery(
        authToken: '', 
        database: _dbName, 
        sql: 'UPDATE $_tableName SET value = $value WHERE name = $_fieldName;',
      ),
    ).fetch()
    .then((result) => Result<String>(error: result.error));
  }
  ///
  Future<Result<String>> fetch() {
    _log.debug('[SqlField.fetch] Fetching value for field \'$_fieldName\'...');
    return ApiRequest(
      address: _apiAddress, 
      sqlQuery: SqlQuery(
        authToken: '', 
        database: _dbName, 
        sql: 'SELECT value FROM $_tableName WHERE name = $_fieldName LIMIT 1;',
      ),
    ).fetch()
    .then((result) => result.fold(
      onData: (apiReply) => Result(data: apiReply.data.first['value'] as String), 
      onError: (error) => Result<String>(error: error),
    ))
    .catchError((error) => Result<String>(error: error));
  }
}