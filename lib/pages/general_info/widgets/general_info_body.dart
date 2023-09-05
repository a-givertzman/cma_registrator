import 'package:cma_registrator/core/models/field/field_datas.dart';
import 'package:cma_registrator/core/widgets/error_message_widget.dart';
import 'package:cma_registrator/core/widgets/future_builder_widget.dart';
import 'package:cma_registrator/pages/general_info/widgets/general_info_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

class GeneralInfoBody extends StatelessWidget {
  final FieldDatas _craneFields;
  final FieldDatas _recorderFields;
  ///
  const GeneralInfoBody({
    super.key, 
    required FieldDatas craneFields, 
    required FieldDatas recorderFields,
  }) : 
    _craneFields = craneFields, 
    _recorderFields = recorderFields;
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
      onFuture: () => Future.wait([_craneFields.all(), _recorderFields.all()]),
      caseLoading: (_) => const Center(
        child: CupertinoActivityIndicator(),
      ),
      validateData: (data) {
        return data.every((e) => !e.hasError);
      },
      caseData: (_, data) {
        final craneDataResult = data[0];
        final recorderDataResult = data[1];
        return GeneralInfoForm(
            craneData: craneDataResult.data, 
            recorderData: recorderDataResult.data,
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