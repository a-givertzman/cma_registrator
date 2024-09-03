import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:cma_registrator/core/models/operating_cycle_details/metric.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class OperatingCycleMetrics {
  static final _log = const Log('OperatingCycleMetrics')..level=LogLevel.debug;
  final String _dbName;
  final String _metricsTableName;
  final String _metricNamesTableName;
  final ApiAddress _apiAddress;
  final OperatingCycle _operatingCycle;
  /// 
  const OperatingCycleMetrics({
    required String dbName,
    required String metricsTableName,
    required String metricNamesTableName,
    required ApiAddress apiAddress,
    required OperatingCycle operatingCycle,
  }) : 
    _dbName = dbName,
    _metricsTableName = metricsTableName,
    _metricNamesTableName = metricNamesTableName,
    _apiAddress = apiAddress,
    _operatingCycle = operatingCycle;
  ///
  Future<ResultF<List<Metric>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return ApiRequest(
      address: _apiAddress, 
      authToken: '', 
      query: SqlQuery(
        database: _dbName, 
        sql: 'SELECT name, value FROM $_metricsTableName as m '
             'JOIN $_metricNamesTableName as n ON n.id=m.metric_id '
             'AND m.operating_cycle_id = ${_operatingCycle.id};',
      ),
    ).fetch()
    .then((result) => switch(result) {
      Ok(value:final apiReply) => Ok(
        apiReply.data
          .map((json) => JsonMetric(json: json))
          .toList(),
      ),
      Err(:final error) => Err(error),
    });
  }
}