import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/models/persistable/database_field.dart';
import 'package:dart_api_client/dart_api_client.dart';
import 'package:hmi_core/hmi_core.dart';
import 'field_type.dart';
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
  Future<Result<List<FieldData>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return ApiRequest(
      address: _apiAddress, 
      sqlQuery: SqlQuery(
        authToken: '', 
        database: _dbName, 
        sql: 'SELECT id, type, description, value FROM $_tableName ORDER BY id ASC;',
      ),
    ).fetch()
    .then((result) =>
      result.fold(
        onData: (apiReply) => Result(
          data: apiReply.data
          .map(
            (map) => FieldData(
              id: map['id'],
              type: FieldType.from(map['type']),
              label: Localized(map['description']).v, 
              initialValue: map['value'], 
              record: DatabaseField(
                id: map['id'],
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
  /// 
  /// Persists changed fields and returns them updated.
  Future<Result<List<FieldData>>> persistAll(List<FieldData> fieldDatas) async {
    _log.debug('[SqlRecord.fetch] Persisting all fields and values from value for field...');
    final changedFields = fieldDatas
      .where((field) => field.isChanged)
      // Copying fields to avoid TextEditingController value changes
      .map((field) => field.copyWith()..controller.text = field.controller.text)
      .toList();
    final valuesString = changedFields
      .map((field) => "('${field.id.trim()}', '${field.controller.text}')")
      .join(', ');
    final requestResult = await ApiRequest(
      address: _apiAddress, 
      sqlQuery: SqlQuery(
        authToken: '', 
        database: _dbName, 
        sql: 'WITH updated(id, value) AS (VALUES $valuesString) ' 
             'UPDATE $_tableName SET value = updated.value ' 
             'FROM updated WHERE ($_tableName.id = updated.id);',
      ),
    ).fetch();
    return requestResult.fold(
      onData: (apiReply) {
        if (apiReply.errors.isEmpty) {
          return Result(
            data: changedFields.map(
              (field) => field.copyWith(
                initialValue: field.controller.text,
              ),
            ).toList(),
          );
        } else {
          return Result(
            error: Failure(
              message: apiReply.errors.first, 
              stackTrace: StackTrace.current,
            ),
          );
        }
      }, 
      onError: (error) => Result(error: error),
    );
  }
}