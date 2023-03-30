import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/pages/general_info/widgets/saving_confirmation_dialog.dart';
import 'package:cma_registrator/pages/tensosensor_calibration/widgets/tensosensor_calibration_step.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
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
  static const _slideDuration = Duration(milliseconds: 300);
  static const _pagesCount = 3;
  late final PageController _pageController;

  final _fieldsData = List.generate(
    _pagesCount - 1, 
    (index) => FieldData(
      viewLabel: const Localized('Target weight').v, 
      initialValue: '0.0',
    ),
  );
  //
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }
  //
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: Iterable<int>
        .generate(_pagesCount)
        .map(_createStepByIndex)
        .toList(), 
    );
  }
  ///
  Widget _createStepByIndex(int index) {
    assert(_pagesCount > 0 && index >= 0);
    if (_pagesCount == 1) {
      return TensosensorCalibrationStep.finishing(
        onFinish: () => _trySaveData(context, () => _slideToPage(0)),
      );
    } else {
      switch(index) {
        case 0:
          return TensosensorCalibrationStep.starter(
            viewIndex: index + 1,
            onNext: () => _slideToPage(index+1),
          );
        case _pagesCount - 1:
          return TensosensorCalibrationStep.finishing(
            viewIndex: index + 1,
            fieldData: _fieldsData[index-1],
            onFinish: () => _trySaveData(context, () => _slideToPage(0)),
            onCancel: () {
              _cancelEditedFields();
              _slideToPage(0);
            },
          );
        default:
          return TensosensorCalibrationStep.intermediate(
            viewIndex: index + 1,
            fieldData: _fieldsData[index-1],
            onNext: () => _slideToPage(index + 1),
            onCancel: () {
              _cancelEditedFields();
              _slideToPage(0);
            },
          );
      }
    }
  }
  ///
  void _slideToPage(int index) => _pageController.animateToPage(
    index, 
    duration: _slideDuration, 
    curve: Curves.easeInOut,
  );
  ///
  void _cancelEditedFields() {
    for(final data in _fieldsData) {
      data.controller.text = data.initialValue;
      data.receivedError = null;
    }
    setState(() { return; });
  }
  ///
  void _trySaveData(BuildContext context, void Function() action) {
    showDialog<bool>(
      context: context, 
      builder: (_) => const SavingConfirmationDialog(),
    ).then((isSaveSubmitted) {
      if (isSaveSubmitted ?? false) {
        action();
      }
    });
    
  }
}