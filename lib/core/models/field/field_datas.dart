import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/models/persistable/sql_field.dart';
import 'package:dart_api_client/dart_api_client.dart';
import 'package:hmi_core/hmi_core.dart';
///
class FieldDatas {
  static final _log = const Log('SqlRecord')..level=LogLevel.debug;
  final String _dbName;
  final String _tableName;
  final ApiAddress _apiAddress;
  /// 
  const FieldDatas({
    required String dbName,
    required String tableName,
    required ApiAddress apiAddress,
  }) : 
    _dbName = dbName,
    _tableName = tableName,
    _apiAddress = apiAddress;
  ///
  Future<Result<List<FieldData>>> all() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return ApiRequest(
      address: _apiAddress, 
      sqlQuery: SqlQuery(
        authToken: '', 
        database: _dbName, 
        sql: 'SELECT name, value FROM $_tableName;',
      ),
    ).fetch()
    .then((result) =>
      result.fold(
        onData: (apiReply) => Result(
          data: apiReply.data
          .map(
            (map) => FieldData(
              label: Localized(map['name']).v, 
              initialValue: map['value'], 
              record: SqlField(
                fieldName: map['name'],
                tableName: _tableName,
                dbName: _dbName, 
                apiAddress: _apiAddress,
              ),
            ),
          ).toList(),
        ), 
        onError: (error) => Result(error: error),
      ),
    );
  }
}