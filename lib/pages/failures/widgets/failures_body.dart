import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'failures_app_bar.dart';
///
class FailuresBody extends StatefulWidget {
  final DateTime? _beginningTime;
  final DateTime? _endingTime;
  final List<DsDataPoint> _points;
  final double _timeColumnWidth;
  ///
  const FailuresBody({
    super.key,
    required List<DsDataPoint> points, 
    DateTime? beginningTime, 
    DateTime? endingTime, 
    double timeColumnWidth = 230,
  }) : 
    _endingTime = endingTime, 
    _beginningTime = beginningTime, 
    _points = points,
    _timeColumnWidth = timeColumnWidth;
  //
  @override
  State<FailuresBody> createState() => _FailuresBodyState(
    points: _points,
    timeColumnWidth: _timeColumnWidth,
    beginningTime: _beginningTime,
    endingTime: _endingTime,
  );
}
///
class _FailuresBodyState extends State<FailuresBody> {
  final Map<String, SplayTreeMap<String, dynamic>> _columns = {};
  late final Map<String, bool> _columnsVisibility;
  final List<String> _timestamps = [];
  final List<DsDataPoint> _points;
  final DateTime? _beginningTime;
  final DateTime? _endingTime;
  final double _timeColumnWidth;
  final ScrollController _vertical = ScrollController();
  final ScrollController _horizontal = ScrollController();
  ///
  _FailuresBodyState({
    required List<DsDataPoint> points,
    required double timeColumnWidth,
    DateTime? beginningTime, 
    DateTime? endingTime,
  }) : _points = points,
    _timeColumnWidth = timeColumnWidth,
    _beginningTime = beginningTime,
    _endingTime = endingTime;
  //
  @override
  void initState() {
    for  (final point in _points) {
      final timestamp = point.timestamp;
      final pointName = point.name.name;
      _timestamps.add(timestamp);
      for (final column in _columns.values) {
        column[timestamp] = column.values.last;
      }
      if(!_columns.containsKey(pointName)) {
        _columns[pointName] = SplayTreeMap();
      }
      _columns[pointName]![timestamp] = point.value;
    }
    _columnsVisibility = Map.fromEntries(
      _columns.keys.map((signal) => MapEntry(signal, true)),
    );
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final signalNames = _columns.keys.toList();
    final filteredSignalNames = signalNames
      .where((signal) => _columnsVisibility[signal] ?? false)
      .toList()
      ..sort();
    final selectedSignalsCount = filteredSignalNames.length;
    return Column(
      children: [
        FailuresAppBar(
          beginningTime: _beginningTime, 
          endingTime: _endingTime,
          columnsVisibility: SplayTreeMap.from(
            Map.fromEntries(
              signalNames.map((signal) => MapEntry(signal, true)),
            ),
          ),
          onChanged: (key, value) {
            setState(() {
              _columnsVisibility[key] = value ?? false;
            });
          },
        ),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: _vertical,
            child: Scrollbar(
              controller: _horizontal,
              thumbVisibility: true,
              notificationPredicate: (notification) => notification.depth == 1,
              child: SingleChildScrollView(
                controller: _vertical,
                child: SingleChildScrollView(
                  controller: _horizontal,
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    columnWidths: [
                      selectedSignalsCount > 0 
                        ? const IntrinsicColumnWidth() 
                        : const FlexColumnWidth(),
                      ...Iterable.generate(
                        selectedSignalsCount,
                        (index) => const IntrinsicColumnWidth(),
                      ),
                    ].asMap(),
                    border: TableBorder.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3)),
                    children: [
                       TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: const Text(
                                'Time', 
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                          ),
                          ...filteredSignalNames.map(
                            (signalName) => TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(padding),
                                child: Text(
                                  signalName,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ..._timestamps.map(
                        (timestamp) => TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(padding),
                                  child: Text(
                                    timestamp,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ),
                            ),
                            ...filteredSignalNames.map(
                              (signalName) => TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(padding),
                                  child: Text(
                                    _columns[signalName]![timestamp]?.toString() ?? '-',
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}