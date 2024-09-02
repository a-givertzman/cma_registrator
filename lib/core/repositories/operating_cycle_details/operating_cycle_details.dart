import 'package:cma_registrator/core/models/event/event.dart';
import 'package:cma_registrator/core/models/event/json_event.dart';
import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/filters_field.dart';
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
    _log.debug('[OperatingCycleDetails.fetchAll] Fetching all operating cycle events...');
    return _fetch(
      'SELECT * FROM $_tableName '
      'WHERE operating_cycle_id=${_operatingCycle.id};'
    );
  }
  ///
  Future<ResultF<List<Event>>> fetchFiltered(Filters filters) {
    const startFilterName = 'start';
    const endFilterName = 'end';
    final startTimestamp = filters.enumerate().where((filter) => filter.name.toLowerCase() == startFilterName).firstOrNull?.rule;
    final endTimestamp = filters.enumerate().where((filter) => filter.name.toLowerCase() == endFilterName).firstOrNull?.rule;
    final valueFilters = filters.enumerate().where((filter) {
      final name = filter.name.toLowerCase();
      return name != startFilterName && name != endFilterName;
    });
    final sqlConditions = ['operating_cycle_id=${_operatingCycle.id}'];
    if(startTimestamp!=null) {
      sqlConditions.add('timestamp>=$startTimestamp');
    }
    if(endTimestamp!=null) {
      sqlConditions.add('timestamp<=$endTimestamp');
    }
    if(valueFilters.isNotEmpty) {
      sqlConditions.addAll(valueFilters.map((filter) => filter.toSqlCondition()));
    }
    if(sqlConditions.length > 1) {
      _log.debug('[OperatingCycleDetails.fetchFiltered] Fetching filtered operating cycle events...');
      final whereCondition = sqlConditions.join(' AND ');
      return _fetch(
        'SELECT * FROM $_tableName '
        'WHERE ($whereCondition);'
      );
    } else {
      return fetchAll();
    }
  }
  ///
  Future<ResultF<List<Event>>> _fetch(String sqlQuery) {
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
          (json) => JsonEvent(json: json),
        ).toList(),
      ),
      Err(:final error) => Err(error),
    });
  }
}