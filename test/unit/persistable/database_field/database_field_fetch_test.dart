import 'dart:convert';
import 'dart:io';
import 'package:cma_registrator/core/models/persistable/database_field.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

void main() {
  Log.initialize();
  group('DatabaseField .fetch()', () {
    const host = 'localhost';
    const port = 0;
    late ServerSocket server;
    final replies = [
      {
        "reply_str": '{"id":"1","authToken":"","data":[{"value":"b"},{"value":"d"},{"value":"f"}]}',
        "reply_data": 'b',
      },
      {
        "reply_str": '{"id":"1","authToken":"","data":[{"value":"321"},{"value":"123"}]}',
        "reply_data": '321',
      },
      {
        "reply_str": '{"id":"1","authToken":"","data":[{"value":"some_Value!2#%\$()"}]}',
        "reply_data": 'some_Value!2#%\$()',
      },
    ];
    int i = 0;
    setUpAll(() async {
      server = await ServerSocket.bind(host, port);
      server.listen(
        (socket) { 
          socket.listen((_) {
            final serializedReply = replies[i]['reply_str']!; 
            i+=1;
            socket.add(utf8.encode(serializedReply));
          });
        },
      );
    });
    tearDownAll(() async {
      await server.close();
    });
    test('pulls data correctly', () async {
      final field = DatabaseField(
        id: '1',
        tableName: 'TestTable',
        dbName: 'TestDb',
        apiAddress: ApiAddress(host: host, port: server.port),
      );
      for(final {'reply_data': targetValue} in replies) {
        final result = await field.fetch();
        expect(result is Ok, isTrue);
        final receivedReply = (result as Ok<String, Failure>).value;
        expect(receivedReply, equals(targetValue));
      }
    });
  });
}