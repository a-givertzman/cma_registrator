import 'package:dart_api_client/dart_api_client.dart';
import 'package:hmi_core/hmi_core.dart';
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
  Future<Result<String>> persist(String value) {
    _log.debug('[SqlField.persist] Persisting value \'$value\' for field with id \'$_id\'...');
    return ApiRequest(
      address: _apiAddress,
      sqlQuery: SqlQuery(
        authToken: '', 
        database: _dbName, 
        sql: 'UPDATE $_tableName SET value = \'$value\' WHERE id = \'$_id\';',
      ),
    ).fetch()
    .then((result) => result.fold(
      onData: (data) => Result(data: data.toString()), 
      onError: (error) => Result(error: error),
    ));
  }
  ///
  Future<Result<String>> fetch() {
    _log.debug('[SqlField.fetch] Fetching value for field with id \'$_id\'...');
    return ApiRequest(
      address: _apiAddress, 
      sqlQuery: SqlQuery(
        authToken: '', 
        database: _dbName, 
        sql: 'SELECT value FROM $_tableName WHERE id = \'$_id\' LIMIT 1;',
      ),
    ).fetch()
    .then((result) => result.fold(
      onData: (apiReply) => Result(data: apiReply.data.first['value'] as String), 
      onError: (error) => Result<String>(error: error),
    ))
    .catchError((error) => Result<String>(error: error));
  }
}