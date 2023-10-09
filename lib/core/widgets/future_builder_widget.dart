import 'package:cma_registrator/core/widgets/button/retry_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'error_message_widget.dart';
/// 
/// Default indicator builder for [FutureBuilderWidget] loading state
Widget _defaultCaseLoading(BuildContext _) => const Center(
  child: CupertinoActivityIndicator(),
);
///
/// Default indicator builder for [FutureBuilderWidget] error state
Widget _defaultCaseError(BuildContext _, Object error) => ErrorMessageWidget(
  message: const Localized('Data loading error').v,
);
///
/// Default indicator builder for [FutureBuilderWidget] empty-data state
Widget _defaultCaseNothing(BuildContext _) => ErrorMessageWidget(
  message: const Localized('No data').v,
);
///
class FutureBuilderWidget<T> extends StatefulWidget {
  final Widget Function(BuildContext)? _caseLoading;
  final Widget Function(BuildContext, T) _caseData;
  final Widget Function(BuildContext, Object)? _caseError;
  final Widget Function(BuildContext)? _caseNothing;
  final bool Function(T)? _validateData;
  final Future<T> Function() _onFuture;
  final Widget _retryLabel;
  
  ///
  const FutureBuilderWidget({
    super.key, 
    required Widget retryLabel,
    required Future<T> Function() onFuture,
    required Widget Function(BuildContext context, T data) caseData,
    Widget Function(BuildContext context)? caseLoading = _defaultCaseLoading,
    Widget Function(BuildContext context, Object error)? caseError = _defaultCaseError,
    Widget Function(BuildContext context)? caseNothing = _defaultCaseNothing, 
    bool Function(T data)? validateData,
  }) : _validateData = validateData, 
    _caseLoading = caseLoading,
    _caseData = caseData,
    _caseError = caseError,
    _caseNothing = caseNothing,
    _onFuture = onFuture,
    _retryLabel = retryLabel;
  //
  @override
  State<FutureBuilderWidget> createState() => _FutureBuilderWidgetState<T>(
    retryLabel: _retryLabel,
    caseLoading: _caseLoading,
    caseData:  _caseData,
    caseError: _caseError,
    caseNothing: _caseNothing,
    onFuture: _onFuture,
    validateData: _validateData,
  );
}
///
class _FutureBuilderWidgetState<T> extends State<FutureBuilderWidget<T>> {
  final Widget Function(BuildContext)? _caseLoading;
  final Widget Function(BuildContext, T)? _caseData;
  final Widget Function(BuildContext, Object)? _caseError;
  final Widget Function(BuildContext)? _caseNothing;
  final bool Function(T)? _validateData;
  final Future<T> Function() _onFuture;
  final Widget _retryLabel;
  late Future<T> _future;
  ///
  _FutureBuilderWidgetState({
    required Widget retryLabel,
    required Widget Function(BuildContext)? caseLoading,
    required Widget Function(BuildContext, T)? caseData,
    required Widget Function(BuildContext, Object)? caseError,
    required Widget Function(BuildContext)? caseNothing,
    required bool Function(T)? validateData,
    required Future<T> Function() onFuture,
  }) : 
    _caseLoading = caseLoading,
    _caseData = caseData,
    _caseError = caseError,
    _caseNothing = caseNothing,
    _onFuture = onFuture,
    _retryLabel = retryLabel,
    _validateData = validateData;
  //
  @override
  void initState() {
    _future = _onFuture();
    super.initState();
  }
  ///
  void _retry() {
    setState(() {
      _future = _onFuture();
    });
  }
  ///
  bool _validate(T data) => _validateData?.call(data) ?? true;
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future, 
      builder: (context, snapshot) {
        final retryButton = RetryButton(
          retryLabel: _retryLabel,
          onRetry: _retry,
        );
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: _caseLoading?.call(context) ?? const SizedBox(),
          );
        }
        if (snapshot.hasData) {
          final data = snapshot.requireData;
          if (_validate(data)) {
            return _caseData?.call(context, data) ?? const SizedBox();
          } else {
            return _WidgetWithRetryButton(
              retryButton: retryButton,
              widget: _caseError?.call(
                context, 
                Failure(
                  message: 'Invalid data', 
                  stackTrace: StackTrace.current,
                ),
              ),
            );
          }
        }
        if (snapshot.hasError) {
          final error = snapshot.error!;
          return _WidgetWithRetryButton(
            retryButton: retryButton,
            widget: _caseError?.call(context, error),
          );
        }
        return _WidgetWithRetryButton(
          retryButton: retryButton,
          widget: _caseNothing?.call(context),
        );
      },
    );
  }
}

class _WidgetWithRetryButton extends StatelessWidget {
  final Widget? _widget;
  final Widget _retryButton;
  ///
  const _WidgetWithRetryButton({
    Widget? widget, 
    required Widget retryButton,
  }) : 
    _retryButton = retryButton, 
    _widget = widget;
  //
  @override
  Widget build(BuildContext context) {
    final widget = _widget;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget != null) ...[
          widget,
          SizedBox(height: const Setting('blockPadding').toDouble),
        ],
        _retryButton,
      ],
    );
  }
}