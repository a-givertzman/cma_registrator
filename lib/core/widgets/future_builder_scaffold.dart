import 'package:cma_registrator/core/widgets/app_bar_widget.dart';
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
class FutureBuilderScaffold<T> extends StatefulWidget {
  final Widget Function(BuildContext)? _caseLoading;
  final Widget Function(BuildContext, T)? _caseData;
  final Widget Function(BuildContext, Object)? _caseError;
  final Widget Function(BuildContext)? _caseNothing;
  final bool Function(T)? _validateData;
  final Future<T> Function() _onFuture;
  final Widget? _retryLabel;
  final String? _title;
  final double _appBarHeight;
  final List<Widget> _appBarLeftWidgets;
  final List<Widget> _appBarRightWidgets;
  final bool _alwaysShowAppBarWidgets;
  ///
  const FutureBuilderScaffold({
    super.key, 
    required Future<T> Function() onFuture,
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
  @override
  State<FutureBuilderScaffold> createState() => _FutureBuilderScaffoldState<T>(
    retryLabel: _retryLabel,
    caseLoading: _caseLoading,
    caseData:  _caseData,
    caseError: _caseError,
    caseNothing: _caseNothing,
    onFuture: _onFuture,
    validateData: _validateData,
    title: _title,
    appBarHeight: _appBarHeight,
    appBarLeftWidgets: _appBarLeftWidgets,
    appBarRightWidgets: _appBarRightWidgets,
    alwaysShowAppBarWidgets: _alwaysShowAppBarWidgets,
  );
}
///
class _FutureBuilderScaffoldState<T> extends State<FutureBuilderScaffold<T>> {
  final Widget Function(BuildContext)? _caseLoading;
  final Widget Function(BuildContext, T)? _caseData;
  final Widget Function(BuildContext, Object)? _caseError;
  final Widget Function(BuildContext)? _caseNothing;
  final bool Function(T)? _validateData;
  final Future<T> Function() _onFuture;
  final Widget? _retryLabel;
  final String? _title;
  final double _appBarHeight;
  final List<Widget> _appBarLeftWidgets;
  final List<Widget> _appBarRightWidgets;
  final bool _alwaysShowAppBarWidgets;
  late Future<T> _future;
  ///
  _FutureBuilderScaffoldState({
    required Widget? retryLabel,
    required Widget Function(BuildContext)? caseLoading,
    required Widget Function(BuildContext, T)? caseData,
    required Widget Function(BuildContext, Object)? caseError,
    required Widget Function(BuildContext)? caseNothing,
    required bool Function(T)? validateData,
    required Future<T> Function() onFuture,
    required String? title,
    required double appBarHeight,
    required List<Widget> appBarLeftWidgets,
    required List<Widget> appBarRightWidgets,
    required bool alwaysShowAppBarWidgets,
  }) : 
    _caseLoading = caseLoading,
    _caseData = caseData,
    _caseError = caseError,
    _caseNothing = caseNothing,
    _onFuture = onFuture,
    _retryLabel = retryLabel,
    _validateData = validateData,
    _title = title,
    _appBarHeight = appBarHeight,
    _appBarLeftWidgets = appBarLeftWidgets,
    _appBarRightWidgets = appBarRightWidgets,
    _alwaysShowAppBarWidgets = alwaysShowAppBarWidgets;
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
        final spacedRetryButton = [
          // const Spacer(), 
          retryButton, 
          SizedBox(width: const Setting('blockPadding').toDouble),
        ];
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(_appBarHeight),
              child: AppBarWidget(
                height: _appBarHeight,
                title: _title,
                leftWidgets: _alwaysShowAppBarWidgets 
                  ? _appBarLeftWidgets 
                  : const [],
                rightWidgets: _alwaysShowAppBarWidgets 
                  ? _appBarRightWidgets 
                  : const [],
              ),
            ),
            body: _caseLoading?.call(context) ?? const SizedBox(),
          );
        }
        if (snapshot.hasData) {
          final data = snapshot.requireData;
          if (_validate(data)) {
            return Scaffold(
              appBar:  PreferredSize(
                preferredSize: Size.fromHeight(_appBarHeight),
                child: AppBarWidget(
                  height: _appBarHeight,
                  title: _title,
                  leftWidgets: _appBarLeftWidgets,
                  rightWidgets: [..._appBarRightWidgets, ...spacedRetryButton],
                ),
              ),
              body: _caseData?.call(context, data) ?? const SizedBox(),
            );
          } else {
            return Scaffold(
              appBar:  PreferredSize(
                preferredSize: Size.fromHeight(_appBarHeight),
                child: AppBarWidget(
                  height: _appBarHeight,
                  title: _title,
                  leftWidgets: _alwaysShowAppBarWidgets 
                  ? _appBarLeftWidgets 
                  : const [],
                  rightWidgets: [
                    if (_alwaysShowAppBarWidgets)
                      ..._appBarRightWidgets,
                    ...spacedRetryButton,
                  ],
                ),
              ),
              body: _caseError?.call(
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
          return Scaffold(
            appBar:  PreferredSize(
              preferredSize: Size.fromHeight(_appBarHeight),
              child: AppBarWidget(
                height: _appBarHeight,
                title: _title,
                leftWidgets: _alwaysShowAppBarWidgets 
                  ? _appBarLeftWidgets 
                  : const [],
                rightWidgets: [
                  if (_alwaysShowAppBarWidgets)
                    ..._appBarRightWidgets,
                  ...spacedRetryButton,
                ],
              ),
            ),
            body: _caseError?.call(context, error),
          );
        }
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(_appBarHeight),
              child: AppBarWidget(
                height: _appBarHeight,
                title: _title,
                leftWidgets: _alwaysShowAppBarWidgets 
                  ? _appBarLeftWidgets 
                  : const [],
                rightWidgets: [
                  if (_alwaysShowAppBarWidgets)
                    ..._appBarRightWidgets,
                  ...spacedRetryButton,
                ],
              ),
            ),
          body: _caseNothing?.call(context),
        );
      },
    );
  }
}