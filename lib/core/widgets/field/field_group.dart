import 'package:flutter/material.dart';

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
    return Column(
      children: [
        Text(
          widget._groupName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.separated(
                controller: _scrollController,
                itemCount: widget._fields.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: widget._fields[index],
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
