import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

///
class FieldGroup extends StatefulWidget {
  final String _groupName;
  final List<Widget> _fields;
  ///
  const FieldGroup({
    super.key,
    required String groupName,
    List<Widget> fields = const [],
  }) : 
    _groupName = groupName,
    _fields = fields;

  @override
  State<FieldGroup> createState() => _FieldGroupState();
}

class _FieldGroupState extends State<FieldGroup> {
  final _scrollController = ScrollController();
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Column(
      children: [
        Text(
          widget._groupName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: blockPadding),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    for (int i = 0; i < widget._fields.length; i++)
                      ...[
                        Padding(
                          padding: EdgeInsets.only(right: padding * 2),
                          child: widget._fields[i],
                        ),
                        if (i == widget._fields.length - 1)
                          SizedBox(height: padding),
                      ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
