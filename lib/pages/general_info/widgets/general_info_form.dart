import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/widgets/button/action_button.dart';
import 'package:cma_registrator/core/widgets/button/cancellation_button.dart';
import 'package:cma_registrator/core/widgets/field/cancelable_field.dart';
import 'package:cma_registrator/core/widgets/field/field_group.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_translate.dart';

import 'confirmation_dialog.dart';

class GeneralInfoForm extends StatefulWidget {
  final List<FieldData> _craneData;
  final List<FieldData> _recorderData;

  const GeneralInfoForm({
    super.key,  
    required List<FieldData> craneData,  
    required List<FieldData> recorderData,
  }) : _craneData = craneData, _recorderData = recorderData;

  @override
  State<GeneralInfoForm> createState() => _GeneralInfoFormState(
    craneData: _craneData,
    recorderData: _recorderData,
  );
}

class _GeneralInfoFormState extends State<GeneralInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final List<FieldData> _craneData;
  final List<FieldData> _recorderData;

  _GeneralInfoFormState({
    required List<FieldData> craneData,  
    required List<FieldData> recorderData,
  }) : _craneData = craneData, _recorderData = recorderData;

  @override
  Widget build(BuildContext context) {
    final isAnyFieldChanged = _craneData
      .where((data) => data.isChanged)
      .followedBy(
        _recorderData
          .where((data) => data.isChanged),
      )
      .isNotEmpty;
    const buttonHeight = 40.0;
    const buttonWidth = 130.0;
    final blockPadding = const Setting('blockPadding').toDouble;
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
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: FieldGroup(
                    groupName: const Localized('Crane').v,
                    fields: _craneData.map(_mapDataToField).toList(),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: FieldGroup(
                    groupName: const Localized('Recorder').v,
                    fields: _recorderData.map(_mapDataToField).toList(),
                  ),
                ),
                const Spacer(flex: 1),
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
    onChanged: (value) => setState(() {
      data.update(value);
    }),
    onCanceled: (_) => setState(() {
      data.cancel();
    }),
    onSaved: (_) {
      return data.save()
        .then((result) {
          if (!result.hasError && mounted) {
            setState(() { return; });
          }
          return result;
        });
    },
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
  void _trySaveData(BuildContext context) {
    final theme = Theme.of(context);
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
          _formKey.currentState?.save();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: theme.cardColor,
          content: Text(
            const Localized('Please, fix all errors before saving!').v,
            style: TextStyle(
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
      );
    }
  }
  ///
  bool _isFormValid() => _formKey.currentState?.validate() ?? false;
}