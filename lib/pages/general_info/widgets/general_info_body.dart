import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:cma_registrator/pages/general_info/widgets/field_data.dart';
import 'field_group.dart';
import 'general_info_field.dart';
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
                TextButton(
                  onPressed: changedFields.isNotEmpty
                      ? _cancelEditedFields
                      : null,
                  child: Text(
                    const Localized('Cancel').v,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: 40,
                  width: 130,
                  child: ElevatedButton(
                    onPressed: changedFields.isNotEmpty
                      ? () => _trySaveData(context, changedFields)
                      : null,
                    child: Text(
                      const Localized('Save').v,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  ///
  GeneralInfoField _mapDataToField(FieldData data) => GeneralInfoField(
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
