import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
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
  Future<ResultF<List<OperatingCycle>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return ApiRequest(
      address: _apiAddress, 
      authToken: '', 
      query: SqlQuery(
        database: _dbName, 
        sql: 'SELECT * FROM $_tableName;',
      ),
    ).fetch()
    .then((result) => switch(result) {
      Ok(value:final apiReply) => Ok(
        apiReply.data.map(
          (json) => JsonOperatingCycle(json: json),
        ).toList(),
      ),
      Err(:final error) => Err(error),
    });
  }
}