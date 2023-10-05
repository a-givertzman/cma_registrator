import 'package:cma_registrator/core/models/field/field_datas.dart';
import 'package:cma_registrator/pages/failures/failures_page.dart';
import 'package:cma_registrator/pages/tensosensor_calibration/tensosensor_calibration_page.dart';
import 'package:cma_registrator/pages/operating_cycles/operating_cycles_page.dart';
import 'package:dart_api_client/dart_api_client.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'widgets/general_info_body.dart';
///
class GeneralInfoPage extends StatelessWidget {
  static const routeName = '/generalInfo';
  ///
  const GeneralInfoPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          const Localized('General info').v,
          style: theme.textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            tooltip: const Localized('Work cycles').v,
            onPressed:  () => Navigator.of(context).pushNamed(
              OperatingCyclesPage.routeName,
            ), 
            icon: Icon(
              Icons.table_chart_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          IconButton(
            tooltip: const Localized('Failures').v,
            onPressed:  () => Navigator.of(context).pushNamed(
              FailuresPage.routeName,
            ), 
            icon: Icon(
              Icons.table_rows_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          IconButton(
            tooltip: const Localized('Tensosensor calibration').v,
            onPressed:  () => Navigator.of(context).pushNamed(
              TensosensorCalibrationPage.routeName,
            ), 
            icon: Icon(
              Icons.settings_applications_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      body: GeneralInfoBody(
        fields: FieldDatas(
          dbName: 'registrator', 
          tableName: 'operating_metric', 
          apiAddress: ApiAddress.localhost(port: 8080),
        ),
      ),
    );
  }
}