import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/widgets/button/action_button.dart';
import 'package:cma_registrator/core/widgets/button/cancellation_button.dart';
import 'package:cma_registrator/core/widgets/field/cancelable_field.dart';
import 'package:cma_registrator/core/widgets/field/field_group.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_core/hmi_core_translate.dart';

import 'confirmation_dialog.dart';

class GeneralInfoForm extends StatefulWidget {
  final List<FieldData> _craneData;
  final List<FieldData> _recorderData;
  final List<FieldData> _operationData;
  final Future<Result<List<FieldData>>> Function()? _onSave;

  const GeneralInfoForm({
    super.key,  
    required List<FieldData> craneData,  
    required List<FieldData> recorderData,
    required List<FieldData> operationData, 
    Future<Result<List<FieldData>>> Function()? onSave,
  }) : _onSave = onSave, 
    _craneData = craneData, 
    _recorderData = recorderData, 
    _operationData = operationData;

  @override
  State<GeneralInfoForm> createState() => _GeneralInfoFormState(
    craneData: _craneData,
    recorderData: _recorderData,
    operationData: _operationData,
    onSave: _onSave,
  );
}

class _GeneralInfoFormState extends State<GeneralInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final List<FieldData> _craneData;
  final List<FieldData> _recorderData;
  final List<FieldData> _operationData;
  final Future<Result<List<FieldData>>> Function()? _onSave;

  _GeneralInfoFormState({
    required List<FieldData> craneData,  
    required List<FieldData> recorderData,
    required List<FieldData> operationData,
    required Future<Result<List<FieldData>>> Function()? onSave,
  }) : 
    _craneData = craneData, 
    _recorderData = recorderData, 
    _operationData = operationData,
    _onSave = onSave;

  @override
  Widget build(BuildContext context) {
    final isAnyFieldChanged = [..._craneData, ..._recorderData, ..._operationData]
      .where((data) => data.isChanged)
      .isNotEmpty;
    const buttonHeight = 40.0;
    const buttonWidth = 130.0;
    final blockPadding = const Setting('blockPadding').toDouble;
    const columnFlex = 3;
    const spacingFlex = 1;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(flex: spacingFlex),
                Expanded(
                  flex: columnFlex,
                  child: FieldGroup(
                    groupName: const Localized('Crane').v,
                    fields: _craneData.map(_mapDataToField).toList(),
                  ),
                ),
                const Spacer(flex: spacingFlex),
                Expanded(
                  flex: 3,
                  child: FieldGroup(
                    groupName: const Localized('Recorder').v,
                    fields: _recorderData.map(_mapDataToField).toList(),
                  ),
                ),
                const Spacer(flex: spacingFlex),
                Expanded(
                  flex: columnFlex,
                  child: FieldGroup(
                    groupName: const Localized('Operation').v,
                    fields: _operationData.map(_mapDataToField).toList(),
                  ),
                ),
                const Spacer(flex: spacingFlex),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CancellationButton(
                  height: buttonHeight,
                  onPressed: isAnyFieldChanged
                    ? _cancelEditedFields
                    : null,
                ),
                SizedBox(width: blockPadding),
                ActionButton(
                  height: buttonHeight,
                  width: buttonWidth,
                  label: const Localized('Save').v,
                  onPressed: isAnyFieldChanged
                    ? () => _trySaveData(context)
                    : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  ///
  CancelableField _mapDataToField(FieldData data) => CancelableField(
    label: data.label,
    initialValue: data.initialValue,
    fieldType: data.type,
    onChanged: (value) => setState(() {
      data.update(value);
    }),
    onCanceled: (_) => setState(() {
      data.cancel();
    }),
    // onSaved: (_) {
    //   return data.save()
    //     .then((result) {
    //       if (!result.hasError && mounted) {
    //         setState(() { return; });
    //       }
    //       return result;
    //     });
    // },
  );
  ///
  void _cancelEditedFields() {
    setState(() {
      for(final data in _craneData) {
        data.cancel();
      }
      for(final data in _recorderData) {
        data.cancel();
      }
    });
  }
  ///
  void _showSnackBarMessage(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.cardColor,
        content: Text(
          message,
          style: TextStyle(
            color: theme.colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
  ///
  void _trySaveData(BuildContext context) {
    if(_isFormValid()) {
      showDialog<bool>(
        context: context, 
        builder: (_) => ConfirmationDialog(
          title: Text(const Localized('Data saving').v),
          content: Text(
            const Localized(
              'Data will be persisted on the server. Do you want to proceed?',
            ).v,
          ),
          confirmationButtonLabel: const Localized('Save').v,
        ),
      ).then((isSaveSubmitted) {
        if (isSaveSubmitted ?? false) {
          setState(() async {
            final onSave = _onSave;
            if(onSave != null) {
              final result = await onSave();
              result.fold(
                onData: (_) {
                  _showSnackBarMessage(context, const Localized('Data saved').v);
                }, 
                onError: (error) {
                  _showSnackBarMessage(context, error.message);
                },
              );
            }
          });
        }
      });
    } else {
      _showSnackBarMessage(
        context, 
        const Localized('Please, fix all errors before saving!').v,
      );
    }
  }
  ///
  bool _isFormValid() => _formKey.currentState?.validate() ?? false;
}