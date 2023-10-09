import 'package:cma_registrator/core/repositories/field/field_datas.dart';
import 'package:dart_api_client/dart_api_client.dart';
import 'package:flutter/material.dart';
import 'widgets/general_info_body.dart';
///
class GeneralInfoPage extends StatelessWidget {
  static const routeName = '/generalInfo';
  ///
  const GeneralInfoPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return GeneralInfoBody(
      fields: FieldDatas(
        dbName: 'registrator', 
        tableName: 'operating_metric', 
        apiAddress: ApiAddress.localhost(port: 8080),
      ),
    );
  }
}