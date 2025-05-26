import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class OperatingCycleEventIds {
  static final _log = const Log('OperatingCycleDetails')..level=LogLevel.debug;
  final String _dbName;
  final String _tableName;
  final OperatingCycle _operatingCycle;
  final ApiAddress _apiAddress;
  /// 
  const OperatingCycleEventIds({
    required String dbName,
    required String tableName,
    required ApiAddress apiAddress,
    required OperatingCycle operatingCycle,
  }) : 
    _dbName = dbName,
    _tableName = tableName,
    _apiAddress = apiAddress,
    _operatingCycle = operatingCycle;
  ///
  Future<ResultF<List<String>>> fetchAll() {
    _log.debug('[OperatingCycleDetails.fetchAll] Fetching all operating cycle event names...');
    return _fetch(
      'SELECT DISTINCT event_id FROM $_tableName '
      'WHERE operating_cycle_id=${_operatingCycle.id};',
    );
  }
  ///
  Future<ResultF<List<String>>> _fetch(String sqlQuery) {
    return ApiRequest(
      address: _apiAddress, 
      authToken: '', 
      query: SqlQuery(
        database: _dbName, 
        sql: sqlQuery,
      ),
    ).fetch()
    .then((result) => switch(result) {
      Ok(value:final apiReply) => Ok(
        apiReply.data.map(
          (json) => '${json['event_id']}',
        ).toList(),
      ),
      Err(:final error) => Err(error),
    });
  }
}