import 'package:cma_registrator/core/models/operating_cycle/metric_info.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class MetricInfos {
  static final _log = const Log('OperatingCycles')..level=LogLevel.debug;
  final String _dbName;
  final String _metricInfoTableName;
  final ApiAddress _apiAddress;
  /// 
  const MetricInfos({
    required String dbName,
    required String metricInfoTableName,
    required ApiAddress apiAddress,
  }) : 
    _dbName = dbName,
    _metricInfoTableName = metricInfoTableName,
    _apiAddress = apiAddress;
  ///
  Future<ResultF<List<MetricInfo>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return _fetch(
      'SELECT id, name, description FROM $_metricInfoTableName',
    );
  }
  ///
  Future<ResultF<List<MetricInfo>>> _fetch(String sqlQuery) {
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
          (json) => JsonMetricInfo(json: json),
        ).toList(),
      ),
      Err(:final error) => Err(error),
    });
  }
}