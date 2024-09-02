import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_details.dart';
import 'package:cma_registrator/core/widgets/future_builder_widget.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/filters_field.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/operating_cycle_details_body.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

class QueriableOperatingCycleDetails extends StatelessWidget {
  const QueriableOperatingCycleDetails({
    super.key,
    required OperatingCycleDetails operatingCycleDetails,
    required OperatingCycle operatingCycle,
  }) : _operatingCycleDetails = operatingCycleDetails, _operatingCycle = operatingCycle;

  final OperatingCycleDetails _operatingCycleDetails;
  final OperatingCycle _operatingCycle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(
            const Setting('blockPadding').toDouble,
          ),
          child: FiltersField(),
        ),
        // Container(
        //   height: 20,
        //   color: Colors.red,
        // ),
        Expanded(
          child: FutureBuilderWidget(
            onFuture: _operatingCycleDetails.fetchAll,
            caseData: (context, points, _) => OperatingCycleDetailsBody(
              operatingCycle: _operatingCycle,
              events: points,
            ),
          ),
        ),
      ],
    );
  }
}