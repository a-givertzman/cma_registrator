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
  // Future<ResultF<List<OperatingCycle>>> fetchFiltered(Filters filters) {
  //   if(filters.enumerate().isEmpty) {
  //     return fetchAll();
  //   }
  //   const startFilterName = 'start';
  //   const endFilterName = 'end';
  //   final startTimestamp = filters.enumerate().where((filter) => filter.name.toLowerCase() == startFilterName).firstOrNull?.rule.value;
  //   final endTimestamp = filters.enumerate().where((filter) => filter.name.toLowerCase() == endFilterName).firstOrNull?.rule.value;
  //   final valueFilters = filters.enumerate().where((filter) {
  //     final name = filter.name.toLowerCase();
  //     return name != startFilterName && name != endFilterName;
  //   });
  //   final sqlConditions = ['operating_cycle_id=${_operatingCycle.id}'];
  //   if(startTimestamp!=null) {
  //     sqlConditions.add("timestamp>='$startTimestamp'");
  //   }
  //   if(endTimestamp!=null) {
  //     sqlConditions.add("timestamp<='$endTimestamp'");
  //   }
  //   if(valueFilters.isNotEmpty) {
  //     sqlConditions.add('(${valueFilters.map((filter) => filter.toSqlCondition()).join(' OR ')})');
  //   }
  //   if(sqlConditions.length > 1) {
  //     _log.debug('[OperatingCycleDetails.fetchFiltered] Fetching filtered operating cycle events...');
  //     final whereCondition = sqlConditions.join(' AND ');
  //     return _fetch(
  //       'SELECT * FROM $_tableName '
  //       'WHERE ($whereCondition);',
  //     );
  //   } else {
  //     return fetchAll();
  //   }
  // }
  ///
  Future<ResultF<List<OperatingCycle>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return _fetch(
      'SELECT oc.id, oc.timestamp_start, oc.timestamp_stop, oc.alarm_class, '
      'COALESCE(NULLIF(json_agg(json_strip_nulls(json_build_object(\'name\',n.name,\'value\', m.value)))::TEXT, \'[{}]\'), \'[]\')::JSON AS metrics '
      'FROM $_operatingCyclesTableName AS oc '
      'LEFT JOIN $_metricsTableName AS m ON m.operating_cycle_id=oc.id '
      'LEFT JOIN $_metricNamesTableName AS n ON n.id=m.metric_id '
      'GROUP BY oc.id;',
    );
  }
  ///
  Future<ResultF<List<OperatingCycle>>> _fetch(String sqlQuery) {
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
          (json) => JsonOperatingCycle(json: json),
        ).toList(),
      ),
      Err(:final error) => Err(error),
    });
  }
}