import 'dart:convert';
import 'dart:io';
import 'package:cma_registrator/core/models/persistable/database_field.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

void main() {
  Log.initialize();
  group('DatabaseField .persist(value)', () {
    const host = 'localhost';
    const port = 9023;
    late ServerSocket server;
    setUpAll(() async {
      server = await ServerSocket.bind(host, port);
      server.listen(
        (socket) { 
          socket.listen((_) {
            socket.add(utf8.encode('{"id":"1","authToken":"","data":[{"a":"b"},{"c":"d"},{"e":"f"}]}'));
          });
        },
      );
    });
    tearDownAll(() async {
      await server.close();
    });
    test('saves data correctly', () async {
      final testStrings = [
        // '',
        '123df',
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz',
      ];
      const field = DatabaseField(
        id: '1',
        tableName: 'TestTable',
        dbName: 'TestDb',
        apiAddress: ApiAddress(host: host, port: port),
      );
      for(final string in testStrings) {
        final result = await field.persist(string);
        expect(result is Ok, isTrue);
      }
    });
  });
}