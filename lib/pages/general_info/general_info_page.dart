import 'package:cma_registrator/core/repositories/field/field_datas.dart';
import 'package:ext_rw/ext_rw.dart';
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
        dbName: 'crane_data_server', 
        tableName: 'operating_metric', 
        apiAddress: ApiAddress.localhost(port: 8080),
      ),
    );
  }
}