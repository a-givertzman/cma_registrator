import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:cma_registrator/core/models/operating_cycle_details/data_point_metrics.dart';
import 'package:cma_registrator/core/models/operating_cycle_details/fold_data_point_metrics.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class OperatingCycleMetrics {
  static final _log = const Log('OperatingCycleMetrics')..level=LogLevel.debug;
  final String _dbName;
  final String _tableName;
  final ApiAddress _apiAddress;
  final OperatingCycle _operatingCycle;
  /// 
  const OperatingCycleMetrics({
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
  Future<ResultF<List<DataPointMetrics>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return ApiRequest(
      address: _apiAddress, 
      authToken: '', 
      query: SqlQuery(
        database: _dbName, 
        sql: 'SELECT * FROM $_tableName '
             'WHERE operating_cycle_id = ${_operatingCycle.id};',
      ),
    ).fetch()
    .then((result) => switch(result) {
      Ok(value:final apiReply) => Ok(
        FoldDataPointMetrics(
          jsons: apiReply.data,
        ).metrics(),
      ),
      Err(:final error) => Err(error),
    });
  }
}