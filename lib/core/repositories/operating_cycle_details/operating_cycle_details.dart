import 'package:cma_registrator/core/models/event/event.dart';
import 'package:cma_registrator/core/models/event/json_event.dart';
import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class OperatingCycleDetails {
  static final _log = const Log('OperatingCycleDetails')..level=LogLevel.debug;
  final String _dbName;
  final String _tableName;
  final OperatingCycle _operatingCycle;
  final ApiAddress _apiAddress;
  /// 
  const OperatingCycleDetails({
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
  Future<ResultF<List<Event>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return ApiRequest(
      address: _apiAddress, 
      authToken: '', 
      query: SqlQuery(
        database: _dbName, 
        sql: 'SELECT * FROM $_tableName '
             'WHERE operating_cycle_id=${_operatingCycle.id};',
      ),
    ).fetch()
    .then((result) => switch(result) {
      Ok(value:final apiReply) => Ok(
        apiReply.data.map(
          (json) => JsonEvent(json: json),
        ).toList(),
      ),
      Err(:final error) => Err(error),
    });
  }
}