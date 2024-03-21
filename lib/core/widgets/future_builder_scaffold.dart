import 'package:cma_registrator/core/widgets/app_bar_widget.dart';
import 'package:cma_registrator/core/widgets/button/retry_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_failure.dart';
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
class FutureBuilderScaffold<T> extends StatefulWidget {
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
  final Future<ResultF<T>> Function() _onFuture;
  final Widget? _retryLabel;
  final String? _title;
  final double _appBarHeight;
  final List<Widget> _appBarLeftWidgets;
  final List<Widget> _appBarRightWidgets;
  final bool _alwaysShowAppBarWidgets;
  late Future<ResultF<T>> _future;
  ///
  _FutureBuilderScaffoldState({
    required Widget? retryLabel,
    required Widget Function(BuildContext)? caseLoading,
    required Widget Function(BuildContext, T)? caseData,
    required Widget Function(BuildContext, Object)? caseError,
    required Widget Function(BuildContext)? caseNothing,
    required bool Function(T)? validateData,
    required Future<ResultF<T>> Function() onFuture,
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
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future, 
      builder: (context, snapshot) {
        final snapshotState = _AsyncSnapshotState.fromSnapshot(
          snapshot,
          _validateData,
        );
        final retryButton = RetryButton(
          retryLabel: _retryLabel,
          onRetry: switch(snapshotState) {
            _LoadingState() => null,
            _ => _retry,
          },
        );
        final spacedRetryButton = [
          retryButton, 
          SizedBox(width: const Setting('blockPadding').toDouble),
        ];
        return switch(snapshotState) {
          _LoadingState() => _FutureBuilderStateWidget(
            appBarHeight: _appBarHeight, 
            title: _title,  
            appBarLeftWidgets: _alwaysShowAppBarWidgets 
              ? _appBarLeftWidgets 
              : const [], 
            appBarRightWidgets: [
              if (_alwaysShowAppBarWidgets)
                ..._appBarRightWidgets,
              ...spacedRetryButton,
            ],
            body: _caseLoading?.call(context),
          ),
          _NothingState() => _FutureBuilderStateWidget(
            appBarHeight: _appBarHeight, 
            title: _title, 
            appBarLeftWidgets: _alwaysShowAppBarWidgets 
              ? _appBarLeftWidgets 
              : const [], 
            appBarRightWidgets: [
              if (_alwaysShowAppBarWidgets)
                ..._appBarRightWidgets,
              ...spacedRetryButton,
            ],
            body:  _caseNothing?.call(context),
          ),
          _DataState<T>(:final data) => _FutureBuilderStateWidget(
            appBarHeight: _appBarHeight, 
            title: _title, 
            appBarLeftWidgets: _appBarLeftWidgets, 
            appBarRightWidgets: [..._appBarRightWidgets, ...spacedRetryButton],
            body: _caseData?.call(context, data),
          ),
          _ErrorState(:final error) => _FutureBuilderStateWidget(
            appBarHeight: _appBarHeight, 
            title: _title, 
            appBarLeftWidgets: _alwaysShowAppBarWidgets 
              ? _appBarLeftWidgets 
              : const [], 
            appBarRightWidgets: [
              if (_alwaysShowAppBarWidgets)
                ..._appBarRightWidgets,
              ...spacedRetryButton,
            ],
            body: _caseError?.call(context, error),
          ),
        };
      },
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
class _FutureBuilderStateWidget extends StatelessWidget {
  const _FutureBuilderStateWidget({
    required double appBarHeight,
    required String? title,
    required List<Widget> appBarLeftWidgets,
    required List<Widget> appBarRightWidgets,
    Widget? body = const SizedBox(),
  }) : 
    _appBarHeight = appBarHeight, 
    _title = title, 
    _appBarLeftWidgets = appBarLeftWidgets, 
    _appBarRightWidgets = appBarRightWidgets,
    _body = body ?? const SizedBox();

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
        appBarRightWidgets: _appBarRightWidgets, 
      ),
      body: _body,
    );
  }
}
///
sealed class _AsyncSnapshotState<T> {
  factory _AsyncSnapshotState.fromSnapshot(
    AsyncSnapshot<ResultF<T>> snapshot,
    bool Function(T)? validateData,
  ) {
    return switch(snapshot) {
      AsyncSnapshot(
        connectionState: ConnectionState.waiting,
      ) => const _LoadingState(),
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: true,
        requireData: final result,
      ) => switch(result) {
        Ok(:final value) => switch(validateData?.call(value) ?? true) {
          true => _DataState(value),
          false => _ErrorState(
            Failure(
              message: 'Invalid data',
              stackTrace: StackTrace.current,
            ),
          ) as _AsyncSnapshotState<T>,
        },
        Err(:final error) => _ErrorState(error),
      },
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: false,
        hasError: true,
        :final error,
        :final stackTrace,
      ) => _ErrorState(
        Failure(
          message: error?.toString() ?? 'Something went wrong',
          stackTrace: stackTrace ?? StackTrace.current,
        ),
      ),
      _ => const _NothingState(),
    };
  }
}
///
final class _LoadingState implements _AsyncSnapshotState<Never> {
  const _LoadingState();
}
///
final class _NothingState implements _AsyncSnapshotState<Never> {
  const _NothingState();
}
///
final class _DataState<T> implements _AsyncSnapshotState<T> {
  final T data;
  const _DataState(this.data);
}
///
final class _ErrorState implements _AsyncSnapshotState<Never> {
  final Failure error;
  const _ErrorState(this.error);
}