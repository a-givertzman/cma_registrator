import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/models/field/field_datas.dart';
import 'package:cma_registrator/core/widgets/error_message_widget.dart';
import 'package:cma_registrator/core/widgets/future_builder_widget.dart';
import 'package:cma_registrator/pages/general_info/widgets/general_info_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

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
    return FutureBuilderWidget(
      retryLabel: Padding(
        padding: EdgeInsets.symmetric(
          vertical: const Setting('padding').toDouble,
        ),
        child: Text(
          const Localized('Retry').v,
          style: theme.textTheme.titleLarge?.copyWith(
            height: 1,
            color: theme.colorScheme.onPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      onFuture: _future,
      caseLoading: (_) => const Center(
        child: CupertinoActivityIndicator(),
      ),
      validateData: (data) {
        return !data.hasError;
      },
      caseData: (_, data) {
        final fields = data.data;
        final craneData = fields.where((field) => field.id.startsWith('1.')).toList();
        final recorderData = fields.where((field) => field.id.startsWith('2.')).toList();
        final operationData = fields.where((field) => field.id.startsWith('3.')).toList();

        return GeneralInfoForm(
            craneData: craneData, 
            recorderData: recorderData,
            operationData: operationData,
            onSave: () => _fields.persistAll(fields),
          );
      },
      caseError: (_, error) => ErrorMessageWidget(
        message: const Localized('Data loading error').v,
      ),
      caseNothing: (context) => ErrorMessageWidget(
        message: const Localized('No data').v,
      ),
    );
  }
}