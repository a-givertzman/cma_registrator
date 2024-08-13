import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/models/field/field_type.dart';
import 'package:cma_registrator/core/models/persistable/database_field.dart';
import 'package:ext_rw/ext_rw.dart' hide FieldType;
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
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
  Future<ResultF<List<FieldData>>> fetchAll() {
    _log.debug('[SqlRecord.fetch] Fetching all fields and values from value for field...');
    return ApiRequest(
      address: _apiAddress, 
      authToken: '', 
      query: SqlQuery(
        database: _dbName, 
        sql: 'SELECT id, type, description, value FROM $_tableName ORDER BY id ASC;',
      ),
    ).fetch()
    .then((result) => switch(result) {
      Ok(value:final apiReply) => Ok(
        apiReply.data
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
      Err(:final error) => Err(error),
    });
  }
  /// 
  /// Persists changed fields and returns them updated.
  Future<ResultF<List<FieldData>>> persistAll(List<FieldData> fieldDatas) async {
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
      authToken: '', 
      query: SqlQuery(
        database: _dbName, 
        sql: 'WITH updated(id, value) AS (VALUES $valuesString) ' 
             'UPDATE $_tableName SET value = updated.value ' 
             'FROM updated WHERE ($_tableName.id = updated.id);',
      ),
    ).fetch();
    return switch(requestResult) {
      Ok(value: final apiReply) => switch(apiReply.hasError) {
        true => Err(
          Failure(
            message: apiReply.error.message,
            stackTrace: StackTrace.current,
          ),
        ),
        false => Ok(
          changedFields.map(
            (field) => field.copyWith(
              initialValue: field.controller.text,
            ),
          ).toList(),
        ),
      },
      Err(:final error) => Err(error),
    };
  }
}