import 'dart:math';
import 'package:cma_registrator/core/widgets/button/action_button.dart';
import 'package:cma_registrator/core/widgets/button/cancellation_button.dart';
import 'package:cma_registrator/core/widgets/field/field_group.dart';
import 'package:cma_registrator/core/widgets/field/cancelable_field.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'saving_confirmation_dialog.dart';
///
class GeneralInfoBody extends StatefulWidget {
  ///
  const GeneralInfoBody({super.key});
  //
  @override
  State<GeneralInfoBody> createState() => _GeneralInfoBodyState();
}
///
class _GeneralInfoBodyState extends State<GeneralInfoBody> {
  final _formKey = GlobalKey<FormState>();
  final _craneData = [
    FieldData(
      viewLabel: const Localized('Type').v,
      initialValue: 'Some type',
    ),
    FieldData(
      viewLabel: const Localized('Index').v,
      initialValue: 'Index value',
    ),
    FieldData(
      viewLabel: const Localized('Manufacturer').v,
      initialValue: 'Manufacturer name',
    ),
    FieldData(
      viewLabel: const Localized('Serial number').v,
      initialValue: '123456789',
    ),
    FieldData(
      viewLabel: const Localized('Manufacture year').v,
      initialValue: '2023',
    ),
    FieldData(
      viewLabel: const Localized('Load capacity').v,
      initialValue: '20t',
    ),
    FieldData(
      viewLabel: const Localized('Modes classification group').v,
      initialValue: 'Group name',
    ),
    FieldData(
      viewLabel: const Localized('Commissioning date').v,
      initialValue: '17.03.2023',
    ),
    FieldData(
      viewLabel: const Localized('Standard service life').v,
      initialValue: '100 years',
    ),
  ];
  final _recorderData = [
    FieldData(
      viewLabel: const Localized('Type').v,
      initialValue: 'Some type',
    ),
    FieldData(
      viewLabel: const Localized('Modification').v,
      initialValue: 'Modification name',
    ),
    FieldData(
      viewLabel: const Localized('Manufacturer').v,
      initialValue: 'Manufacturer name',
    ),
    FieldData(
      viewLabel: const Localized('Serial number').v,
      initialValue: '123456789',
    ),
    FieldData(
      viewLabel: const Localized('Manufacture year').v,
      initialValue: '2023',
    ),
    FieldData(
      viewLabel: const Localized('Date of installation on the crane').v,
      initialValue: '18.03.2023',
    ),
    FieldData(
      viewLabel: const Localized('Organization that installed sensor on the crane').v,
      initialValue: 'Organization name',
    ),
  ];
  //
  @override
  Widget build(BuildContext context) {
    const buttonHeight = 40.0;
    const buttonWidth = 130.0;
    final blockPadding = const Setting('blockPadding').toDouble;
    final changedFields = [
      ..._craneData.where((data) => data.initialValue != data.controller.text),
      ..._recorderData.where((data) => data.initialValue != data.controller.text),
    ];
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
                  onPressed: changedFields.isNotEmpty
                    ? _cancelEditedFields
                    : null,
                ),
                SizedBox(width: blockPadding),
                ActionButton(
                  height: buttonHeight,
                  width: buttonWidth,
                  label: const Localized('Save').v,
                  onPressed: changedFields.isNotEmpty
                    ? () => _trySaveData(context, changedFields)
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
    label: data.viewLabel,
    initialValue: data.initialValue,
    controller: data.controller,
    sendError: data.receivedError,
    onChanged: (_) => setState(() { return; }),
    onCanceled: (_) => setState(() {
      data.receivedError = null;
    }),
  );
  ///
  void _cancelEditedFields() {
    for(final data in _craneData) {
      data.controller.text = data.initialValue;
      data.receivedError = null;
    }
    for(final data in _recorderData) {
      data.controller.text = data.initialValue;
      data.receivedError = null;
    }
    setState(() { return; });
  }
  ///
  void _trySaveData(BuildContext context, List<FieldData> changedFields) {
    final theme = Theme.of(context);
    if(_isFormValid()) {
      showDialog<bool>(
        context: context, 
        builder: (_) => const SavingConfirmationDialog(),
      ).then((isSaveSubmitted) {
        if (isSaveSubmitted ?? false) {
          final random = Random();
          setState(() {
            for(final field in changedFields) {
              if (random.nextDouble() < 0.9) {
                field.initialValue = field.controller.text;
                field.receivedError = null;
              } else {
                field.receivedError = const Localized('Something went wrong').v;
              }
            }
          });
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
