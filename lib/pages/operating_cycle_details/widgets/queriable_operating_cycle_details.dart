import 'dart:developer';

import 'package:cma_registrator/core/models/filter/filters.dart';
import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_details.dart';
import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_events.dart';
import 'package:cma_registrator/core/widgets/future_builder_widget.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/filters_field.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/operating_cycle_details_body.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

class QueriableOperatingCycleDetails extends StatefulWidget {
  const QueriableOperatingCycleDetails({
    super.key,
    required OperatingCycleDetails operatingCycleDetails,
    required OperatingCycle operatingCycle,
    required OperatingCycleEventIds operatingCycleEventIds,
  }) :
    _operatingCycleDetails = operatingCycleDetails,
    _operatingCycle = operatingCycle,
    _operatingCycleEventIds = operatingCycleEventIds;

  final OperatingCycleDetails _operatingCycleDetails;
  final OperatingCycle _operatingCycle;
  final OperatingCycleEventIds _operatingCycleEventIds;

  @override
  State<QueriableOperatingCycleDetails> createState() => _QueriableOperatingCycleDetailsState();
}

class _QueriableOperatingCycleDetailsState extends State<QueriableOperatingCycleDetails> {
  late final ValueNotifier<Filters> _filtersNotifier;
  @override
  void initState() {
    _filtersNotifier = ValueNotifier(const Filters.empty());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(
            const Setting('blockPadding').toDouble,
          ),
          child: FutureBuilderWidget(
            onFuture: widget._operatingCycleEventIds.fetchAll,
            caseData: (context, signalNames, _) => FiltersField(
              filtersNotifier: _filtersNotifier,
              signalNames: signalNames,
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _filtersNotifier,
            builder: (context, filters, child) {
              log('ValueListenableBuilder: ${filters.enumerate()}');
              return FutureBuilderWidget(
                key: ValueKey(filters),
                onFuture: () => widget._operatingCycleDetails.fetchFiltered(filters),
                caseData: (context, points, _) => OperatingCycleDetailsBody(
                  operatingCycle: widget._operatingCycle,
                  events: points,
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}