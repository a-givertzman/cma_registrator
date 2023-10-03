import 'package:cma_registrator/core/models/work_cycle/metric.dart';
import 'package:cma_registrator/core/models/work_cycle/work_cycle_point.dart';
import 'package:dart_api_client/dart_api_client.dart';
import 'package:hmi_core/hmi_core.dart';
///
class WorkCyclePoints {
  static final _log = const Log('WorkCycles')..level=LogLevel.debug;
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
          data: apiReply.data
          .fold(
            <(int, String), WorkCyclePoint>{}, 
            (previousValue, element) {
              final workCycleId = element['operating_cycle_id'] as int;
              final pointName = element['point_name'] as String;
              final key = (workCycleId, pointName);
              if(previousValue.containsKey(key)) {
                final oldWorkCycle = previousValue[key]!;
                final newWorkCycle = WorkCyclePoint(
                  start: oldWorkCycle.start,
                  stop: oldWorkCycle.stop,
                  name: oldWorkCycle.name, 
                  metrics: [...oldWorkCycle.metrics, Metric.fromDbRow(element)],
                );
                return previousValue..addAll({
                  key: newWorkCycle,
                });
              } else { 
                return previousValue..addAll({
                  key: WorkCyclePoint(
                    start: DateTime.parse(element['start']),
                    stop: DateTime.parse(element['stop']),
                    name: DsPointName(element['point_name']), 
                    metrics: [Metric.fromDbRow(element)],
                  ),
                });
              }
            },
          ).values.toList(),
        ), 
        onError: (error) => Result(error: error),
      ),
    );
  }
}