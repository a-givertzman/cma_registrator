import 'package:cma_registrator/core/repositories/field/field_datas.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
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
        dbName: const Setting('api-database').toString(),
        tableName: 'public.rec_basic_metric', 
        apiAddress: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      ),
    );
  }
}