import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:dart_api_client/dart_api_client.dart';
import 'package:hmi_core/hmi_core.dart';
///
class OperatingCycles {
  static final _log = const Log('OperatingCycles')..level=LogLevel.debug;
  final String _dbName;
  final String _tableName;
  final ApiAddress _apiAddress;
  /// 
  const OperatingCycles({
    required String dbName,
    required String tableName,
    required ApiAddress apiAddress,
  }) : 
    _dbName = dbName,
    _tableName = tableName,
    _apiAddress = apiAddress;
  ///
  Future<Result<List<OperatingCycle>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return ApiRequest(
      address: _apiAddress, 
      sqlQuery: SqlQuery(
        authToken: '', 
        database: _dbName, 
        sql: 'SELECT * FROM $_tableName;',
      ),
    ).fetch()
    .then((result) =>
      result.fold(
        onData: (apiReply) => Result(
          data: apiReply.data.map(
            (json) => JsonOperatingCycle(json: json),
          ).toList(),
        ), 
        onError: (error) => Result(error: error),
      ),
    );
  }
}