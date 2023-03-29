import 'dart:math';

import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/widgets/field/cancelable_field.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
enum StepType {
  starter,
  intermediate,
  finishing,
}
///
class TensosensorCalibrationStep extends StatefulWidget {
  final int? _viewIndex;
  final FieldData? _fieldData;
  final StepType _stepType;
  final void Function()? _onNext;
  final void Function()? _onFinish;
  final void Function()? _onCancel;
  ///
  const TensosensorCalibrationStep({
    super.key, 
    required StepType stepType,
    FieldData? fieldData,
    void Function()? onNext, 
    void Function()? onFinish, 
    void Function()? onCancel, 
    int? viewIndex, 
  }) : 
    _viewIndex = viewIndex, 
    _fieldData = fieldData,
    _stepType = stepType, 
    _onCancel = onCancel, 
    _onFinish = onFinish, 
    _onNext = onNext;
  ///
  const TensosensorCalibrationStep.starter({
    Key? key,
    int? viewIndex,
    void Function()? onNext,
  }) : this(
    key: key, 
    viewIndex: viewIndex,
    stepType: StepType.starter,
    onNext: onNext,
  );
  ///
  const TensosensorCalibrationStep.intermediate({
    Key? key,
    required FieldData fieldData,
    int? viewIndex,
    void Function()? onNext,
    void Function()? onCancel,
  }) : this(
    key: key,
    fieldData: fieldData,
    viewIndex: viewIndex,
    stepType: StepType.intermediate,
    onNext: onNext,
    onCancel: onCancel,
  );
  ///
  const TensosensorCalibrationStep.finishing({
    Key? key,
    int? viewIndex,
    FieldData? fieldData,
    void Function()? onFinish,
    void Function()? onCancel,
  }) : this(
    key: key,
    fieldData: fieldData,
    viewIndex: viewIndex,
    stepType: StepType.finishing,
    onFinish: onFinish,
    onCancel: onCancel,
  );
  //
  @override
  State<TensosensorCalibrationStep> createState() => _TensosensorCalibrationStepState(
    onNext: _onNext,
    onFinish: _onFinish,
    onCancel: _onCancel,
    stepType: _stepType,
    fieldData: _fieldData,
    viewIndex: _viewIndex,
  );
}
///
class _TensosensorCalibrationStepState extends State<TensosensorCalibrationStep> {
  final _formKey = GlobalKey<FormState>();
  final StepType _stepType;
  final int? _viewIndex;
  final FieldData? _fieldData;
  final void Function()? _onNext;
  final void Function()? _onFinish;
  final void Function()? _onCancel;
  ///
  _TensosensorCalibrationStepState({
    required StepType stepType,
    int? viewIndex,
    FieldData? fieldData,
    void Function()? onNext, 
    void Function()? onFinish, 
    void Function()? onCancel,
  }) : 
    _viewIndex = viewIndex,
    _fieldData = fieldData,
    _stepType = stepType,
    _onCancel = onCancel, 
    _onFinish = onFinish, 
    _onNext = onNext;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding',factor: 5).toDouble;
    final random = Random();
    final fieldData = _fieldData;
    final indexText = _viewIndex != null ? '$_viewIndex. ' : '';
    final headline = '$indexText${Localized(
      _stepType == StepType.starter 
      ? 'Baseline calibration'
      : 'Calibration for the selected weight',
    )}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          headline,
          style: const TextStyle(fontSize: 18),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(_stepType != StepType.starter && fieldData != null) ...[
                  SizedBox(
                    width: 200,
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: _mapDataToField(fieldData),
                    ),
                  ),
                  SizedBox(width: padding),
                ],
              TextIndicatorWidget(
                height: 50,
                width: 150,
                indicator: TextValueIndicator(
                  stream: Stream.periodic(
                    const Duration(milliseconds: 500),
                    (_) => DsDataPoint(
                      type: DsDataType.real, 
                      name: DsPointName('/test'), 
                      value: random.nextDouble() * 40000, 
                      status: DsStatus.ok, 
                      timestamp: DsTimeStamp.now().toString(),
                    ),
                  ),
                  valueUnit: const Localized('kg').v,
                ), 
                caption: Text(const Localized('Sensor value').v), 
                alignment: Alignment.topRight,
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _getButtons(_stepType),
          ),
        ),
      ],
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
    validator: const Validator(
      cases: [
        OnlyDigitsValidationCase(),
      ],
    ),
  );
  ///
  List<Widget> _getButtons(StepType stepType) {
    final padding = const Setting('padding').toDouble;
    return [
      if(stepType != StepType.starter)
        TextButton(
          onPressed: _onCancel, 
          child: Text(
            const Localized('Cancel').v, 
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      if(stepType != StepType.finishing) ...[
        SizedBox(width: padding),
        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              if((_formKey.currentState?.validate() ?? false)
                || _stepType == StepType.starter) {
                _onNext?.call();
              }
            }, 
            child: Text(
              const Localized('Next').v, 
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ]
      else ...[
        SizedBox(width: padding),
        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              if(_formKey.currentState?.validate() ?? false) {
                _onFinish?.call();
              }
            }, 
            child: Text(
              const Localized('Save and finish').v, 
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    ];
  }
}