import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class OperatingCycles {
  static final _log = const Log('OperatingCycles')..level=LogLevel.debug;
  final String _dbName;
  final String _operatingCyclesTableName;
  final String _metricsTableName;
  final String _metricNamesTableName;
  final ApiAddress _apiAddress;
  /// 
  const OperatingCycles({
    required String dbName,
    required String operatingCyclesTableName,
    required String metricsTableName,
    required String metricNamesTableName,
    required ApiAddress apiAddress,
  }) : 
    _dbName = dbName,
    _operatingCyclesTableName = operatingCyclesTableName,
    _metricsTableName = metricsTableName,
    _metricNamesTableName = metricNamesTableName,
    _apiAddress = apiAddress;
  ///
  Future<ResultF<List<OperatingCycle>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return ApiRequest(
      address: _apiAddress, 
      authToken: '', 
      query: SqlQuery(
        database: _dbName, 
        sql: 'SELECT oc.id as id, timestamp_start, timestamp_stop, alarm_class, '
             'json_agg(json_build_object(\'name\',n.name,\'value\', m.value)) as metrics '
             'FROM $_operatingCyclesTableName as oc '
             'LEFT JOIN $_metricsTableName as m ON m.operating_cycle_id=oc.id '
             'LEFT JOIN $_metricNamesTableName as n ON n.id=m.metric_id '
             'GROUP BY oc.id;',
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