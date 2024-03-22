import 'package:cma_registrator/core/widgets/app_bar_widget.dart';
import 'package:cma_registrator/core/widgets/button/retry_button.dart';
import 'package:cma_registrator/core/widgets/future_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
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
class FutureBuilderScaffold<T> extends StatelessWidget {
  final Widget Function(BuildContext)? _caseLoading;
  final Widget Function(BuildContext, T)? _caseData;
  final Widget Function(BuildContext, Object)? _caseError;
  final Widget Function(BuildContext)? _caseNothing;
  final bool Function(T)? _validateData;
  final Future<ResultF<T>> Function() _onFuture;
  final Widget? _retryLabel;
  final String? _title;
  final double _appBarHeight;
  final List<Widget> _appBarLeftWidgets;
  final List<Widget> _appBarRightWidgets;
  final bool _alwaysShowAppBarWidgets;
  ///
  const FutureBuilderScaffold({
    super.key, 
    required Future<ResultF<T>> Function() onFuture,
    Widget? retryLabel,
    Widget Function(BuildContext context)? caseLoading = _defaultCaseLoading,
    Widget Function(BuildContext context, T data)? caseData,
    Widget Function(BuildContext context, Object error)? caseError = _defaultCaseError,
    Widget Function(BuildContext context)? caseNothing = _defaultCaseNothing, 
    bool Function(T data)? validateData,
    String? title,
    double appBarHeight = 56.0,
    List<Widget> appBarLeftWidgets = const [],
    List<Widget> appBarRightWidgets = const [],
    bool alwaysShowAppBarWidgets = false,
  }) : _validateData = validateData, 
    _caseLoading = caseLoading,
    _caseData = caseData,
    _caseError = caseError,
    _caseNothing = caseNothing,
    _onFuture = onFuture,
    _retryLabel = retryLabel,
    _title = title,
    _appBarHeight = appBarHeight,
    _appBarLeftWidgets = appBarLeftWidgets,
    _appBarRightWidgets = appBarRightWidgets,
    _alwaysShowAppBarWidgets = alwaysShowAppBarWidgets;
  //
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilderWidget(
      onFuture: _onFuture,
      validateData: _validateData,
      caseData: (context, data, retry) => _FutureBuilderScaffoldStateWidget(
        appBarHeight: _appBarHeight, 
        title: _title, 
        appBarLeftWidgets: _appBarLeftWidgets, 
        appBarRightWidgets: _appBarRightWidgets,
        onRetry: retry,
        retryLabel: _retryLabel,
        body: _caseData?.call(context, data),
      ),
      caseError: (context, error, retry) => _FutureBuilderScaffoldStateWidget(
        appBarHeight: _appBarHeight, 
        title: _title, 
        appBarLeftWidgets: _alwaysShowAppBarWidgets 
          ? _appBarLeftWidgets 
          : const [], 
        appBarRightWidgets: _alwaysShowAppBarWidgets ? _appBarRightWidgets : [],
        onRetry: retry,
        retryLabel: _retryLabel,
        body: _caseError?.call(context, error),
      ),
      caseLoading: (context) => _FutureBuilderScaffoldStateWidget(
        appBarHeight: _appBarHeight, 
        title: _title,  
        appBarLeftWidgets: _alwaysShowAppBarWidgets 
          ? _appBarLeftWidgets 
          : const [], 
        appBarRightWidgets: _alwaysShowAppBarWidgets ? _appBarRightWidgets : [],
        onRetry: null,
        retryLabel: _retryLabel,
        body: _caseLoading?.call(context),
      ),
      caseNothing: (context, retry) => _FutureBuilderScaffoldStateWidget(
        appBarHeight: _appBarHeight, 
        title: _title, 
        appBarLeftWidgets: _alwaysShowAppBarWidgets 
          ? _appBarLeftWidgets 
          : const [], 
        appBarRightWidgets: _alwaysShowAppBarWidgets ? _appBarRightWidgets : [],
        onRetry: retry,
        retryLabel: _retryLabel,
        body:  _caseNothing?.call(context),
      ),
    );
  }
}
///
class _AppBar extends PreferredSize {
  _AppBar({
    Key? key,
    required double appBarHeight,
    required String? title,
    required List<Widget> appBarLeftWidgets,
    required List<Widget> appBarRightWidgets,
  }) : super(
      key: key, 
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBarWidget(
        height: appBarHeight,
        title: title,
        leftWidgets: appBarLeftWidgets,
        rightWidgets: appBarRightWidgets,
      ),
    );
}
///
class _FutureBuilderScaffoldStateWidget extends StatelessWidget {
  const _FutureBuilderScaffoldStateWidget({
    required double appBarHeight,
    required String? title,
    required List<Widget> appBarLeftWidgets,
    required List<Widget> appBarRightWidgets,
    Widget? retryLabel,
    void Function()? onRetry,
    Widget? body = const SizedBox(),
  }) : 
    _appBarHeight = appBarHeight, 
    _title = title, 
    _appBarLeftWidgets = appBarLeftWidgets, 
    _appBarRightWidgets = appBarRightWidgets,
    _retryLabel = retryLabel,
    _onRetry = onRetry,
    _body = body ?? const SizedBox();
  final Widget? _retryLabel;
  final void Function()? _onRetry;
  final double _appBarHeight;
  final String? _title;
  final List<Widget> _appBarLeftWidgets;
  final List<Widget> _appBarRightWidgets;
  final Widget _body;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  _AppBar(
        appBarHeight: _appBarHeight, 
        title: _title, 
        appBarLeftWidgets: _appBarLeftWidgets, 
        appBarRightWidgets: [
          ..._appBarRightWidgets,
          RetryButton(
            retryLabel: _retryLabel,
            onRetry: _onRetry,
          ),
          SizedBox(width: const Setting('blockPadding').toDouble),
        ], 
      ),
      body: Expanded(child: _body),
    );
  }
}
