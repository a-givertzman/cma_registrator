import 'dart:math';
import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/widgets/field/field_group.dart';
import 'package:cma_registrator/core/widgets/field/general_info_field.dart';
import 'package:cma_registrator/pages/general_info/widgets/saving_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class TensosensorCalibrationBody extends StatefulWidget {
  ///
  const TensosensorCalibrationBody({super.key});
  //
  @override
  State<TensosensorCalibrationBody> createState() => _TensosensorCalibrationBodyState();
}
///
class _TensosensorCalibrationBodyState extends State<TensosensorCalibrationBody> {
  final _formKey = GlobalKey<FormState>();
  final _lData = [
    FieldData(
      viewLabel: const Localized('M2L').v,
      initialValue: '2454900',
    ),
    FieldData(
      viewLabel: const Localized('M1L').v,
      initialValue: '2454900',
    ),
    FieldData(
      viewLabel: const Localized('SL').v,
      initialValue: '2454900',
    ),
    FieldData(
      viewLabel: const Localized('WL').v,
      initialValue: '2454900',
    ),
  ];
  final _rData = [
    FieldData(
      viewLabel: const Localized('M2R').v,
      initialValue: '2456125',
    ),
    FieldData(
      viewLabel: const Localized('M1R').v,
      initialValue: '2456125',
    ),
    FieldData(
      viewLabel: const Localized('SR').v,
      initialValue: '2456125',
    ),
    FieldData(
      viewLabel: const Localized('WR').v,
      initialValue: '2456125',
    ),
  ];
  //
  @override
  Widget build(BuildContext context) {
    final changedFields = [
      ..._lData,
      ..._rData,
    ].where((data) => data.initialValue != data.controller.text);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: FieldGroup(
                    groupName:  '',
                    fields: _lData.map(_mapDataToField).toList(),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: FieldGroup(
                    groupName: '',
                    fields: _rData.map(_mapDataToField).toList(),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
          Expanded(
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
  InfoField _mapDataToField(FieldData data) => InfoField(
    label: data.viewLabel,
    initialValue: data.initialValue,
    controller: data.controller,
    sendError: data.receivedError,
    onChanged: (_) => setState(() { return; }),
    onCanceled: (_) => setState(() {
      data.receivedError = null;
    }),
    validator: const Validator(
      cases: [
        OnlyDigitsValidationCase(),
      ],
    ),
  );
  ///
  void _cancelEditedFields() {
    for(final data in _lData) {
      data.controller.text = data.initialValue;
      data.receivedError = null;
    }
    setState(() { return; });
  }
  ///
  void _trySaveData(BuildContext context, Iterable<FieldData> changedFields) {
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
              if (random.nextDouble() < 0.8) {
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