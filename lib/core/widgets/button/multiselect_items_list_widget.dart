import 'package:cma_registrator/core/widgets/ink_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

///
class MultiselectItemsListWidget extends StatefulWidget {
  final double _width;
  final double _itemHeight;
  final double _listBorderRadius;
  final double _shadowBlurRadius;
  final Offset _shadowOffset;
  final Map<String, bool> _multiselectItems;
  final void Function(String, bool?)? _onChanged;
  ///
  const MultiselectItemsListWidget({
    Key? key,
    required Map<String, bool> multiselectItems, 
    required double width, 
    required double itemHeight,
    void Function(String key, bool? value)? onChanged, 
    double listBorderRadius = 16.0, 
    double shadowBlurRadius = 6.0, 
    Offset shadowOffset = const Offset(0, 1),
  }) : 
    _shadowOffset = shadowOffset, 
    _shadowBlurRadius = shadowBlurRadius, 
    _listBorderRadius = listBorderRadius, 
    _multiselectItems = multiselectItems, 
    _width = width,
    _itemHeight = itemHeight,
    _onChanged = onChanged, 
    super(key: key);
  //
  @override
  State<MultiselectItemsListWidget> createState() => _MultiselectItemsListWidgetState(
    multiselectItems: _multiselectItems,
    width: _width,
    itemHeight: _itemHeight,
    onChanged: _onChanged, 
    listBorderRadius: _listBorderRadius, 
    shadowBlurRadius: _shadowBlurRadius,
    shadowOffset: _shadowOffset,
  );
}
///
class _MultiselectItemsListWidgetState extends State<MultiselectItemsListWidget> {
  final double _width;
  final double _itemHeight;
  final double _listBorderRadius;
  final double _shadowBlurRadius;
  final Offset _shadowOffset;
  final Map<String, bool> _multiselectItems;
  final void Function(String, bool?)? _onChanged;
  ///
  _MultiselectItemsListWidgetState({
    required Map<String, bool> multiselectItems, 
    required double width, 
    required double itemHeight,
    required double listBorderRadius,
    required double shadowBlurRadius,
    required Offset shadowOffset,
    void Function(String key, bool? value)? onChanged,
  }) : 
    _multiselectItems = multiselectItems, 
    _width = width,
    _itemHeight = itemHeight,
    _listBorderRadius = listBorderRadius,
    _shadowBlurRadius = shadowBlurRadius,
    _shadowOffset = shadowOffset,
    _onChanged = onChanged;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    final entries = _multiselectItems.entries.toList();
    return Container(
      width: _width,
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(_listBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.4),
            offset: _shadowOffset,
            blurRadius: _shadowBlurRadius,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_listBorderRadius),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(int i = 0; i < entries.length; i++)
                  Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: _width,
                      height: _itemHeight,
                      child: InkWrapper(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () {
                          final newValue = !_multiselectItems[entries[i].key]!;
                          _onChanged?.call(entries[i].key, newValue);
                          setState(() {
                            _multiselectItems[entries[i].key] = newValue;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(padding),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            border: _getBorderByIndex(i, entries.length),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(entries[i].key),
                              const Spacer(),
                              Checkbox(
                                activeColor: theme.colorScheme.primary,
                                value: entries[i].value, 
                                onChanged: (value) {
                                  _onChanged?.call(entries[i].key, value);
                                  setState(() {
                                    _multiselectItems[entries[i].key] = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  ///
  Border _getBorderByIndex(int index, int length) {
    const borderSide = BorderSide(color: Colors.white10);
    if(index == 0) {
      return const Border(bottom: borderSide);
    }
    if(index == length-1) {
      return const Border(top: borderSide);
    }
    return const Border.symmetric(horizontal: borderSide);
  }
}