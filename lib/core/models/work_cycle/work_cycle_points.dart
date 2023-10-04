import 'package:cma_registrator/core/models/work_cycle/fold_data_point_metrics.dart';
import 'package:cma_registrator/core/models/work_cycle/work_cycle_point.dart';
import 'package:dart_api_client/dart_api_client.dart';
import 'package:hmi_core/hmi_core.dart';
///
class WorkCyclePoints {
  static final _log = const Log('WorkCyclePoints')..level=LogLevel.debug;
  final String _dbName;
  final String _tableName;
  final ApiAddress _apiAddress;
  /// 
  const WorkCyclePoints({
    required String dbName,
    required String tableName,
    required ApiAddress apiAddress,
  }) : 
    _dbName = dbName,
    _tableName = tableName,
    _apiAddress = apiAddress;
  ///
  Future<Result<List<WorkCyclePoint>>> fetchAll() {
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
          data: FoldDataPointMetrics(
            jsons: apiReply.data,
          ).workCycles(),
        ), 
        onError: (error) => Result(error: error),
      ),
    );
  }
}