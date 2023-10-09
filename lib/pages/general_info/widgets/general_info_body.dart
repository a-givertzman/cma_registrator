import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/repositories/field/field_datas.dart';
import 'package:cma_registrator/core/widgets/future_builder_scaffold.dart';
import 'package:cma_registrator/pages/general_info/widgets/general_info_form.dart';
import 'package:cma_registrator/pages/operating_cycles/operating_cycles_page.dart';
import 'package:cma_registrator/pages/tensosensor_calibration/tensosensor_calibration_page.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

class GeneralInfoBody extends StatelessWidget {
  // static final _log = const Log('GeneralInfoBody')..level=LogLevel.warning;
  final FieldDatas _fields;
  ///
  const GeneralInfoBody({
    super.key, 
    required FieldDatas fields, 
  }) : 
    _fields = fields;
  Future<Result<List<FieldData>>> _future() async {
    final fields = await _fields.fetchAll();
    return fields;
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilderScaffold(
      title: const Localized('General info').v,
      alwaysShowAppBarWidgets: true,
      appBarHeight: 72.0,
      appBarRightWidgets: [
        const Spacer(),
        Row(
          children: [
            IconButton(
              tooltip: const Localized('Operating cycles').v,
              onPressed:  () => Navigator.of(context).pushNamed(
                OperatingCyclesPage.routeName,
              ), 
              icon: Icon(
                Icons.table_chart_outlined,
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
        const Spacer(),
      ],
      onFuture: _future,
      validateData: (data) {
        return !data.hasError;
      },
      caseData: (_, data) {
        final fields = data.data;
        return GeneralInfoForm(
            fieldData: fields, 
            onSave: () => _fields.persistAll(fields),
          );
      },
    );
  }
}