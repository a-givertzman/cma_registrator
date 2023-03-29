import 'package:cma_registrator/core/widgets/button/multiselect_items_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
class DropdownMultiselectButton extends StatefulWidget {
  final double? _height;
  final double? _width;
  final double? _itemHeight;
  final double? _menuWidth;
  final String? _label;
  final Map<String, bool> _items;
  final void Function(String, bool?)? _onChanged;
  ///
  const DropdownMultiselectButton({
    super.key, 
    required Map<String, bool> items, 
    String? label, 
    double? height, 
    double? width, 
    double? itemHeight, 
    double? menuWidth, 
    void Function(String, bool?)? onChanged,
  }) : 
    _onChanged = onChanged, 
    _menuWidth = menuWidth, 
    _itemHeight = itemHeight, 
    _height = height, 
    _width = width, 
    _label = label, 
    _items = items;
  //
  @override
  State<DropdownMultiselectButton> createState() => _DropdownMultiselectButtonState(
    items: _items,
    label: _label,
    height: _height,
    width: _width,
    itemHeight: _itemHeight,
    menuWidth: _menuWidth,
    onChanged: _onChanged,
  );
}
///
class _DropdownMultiselectButtonState extends State<DropdownMultiselectButton> {
  final double? _height;
  final double? _width;
  final double? _itemHeight;
  final double? _menuWidth;
  final String? _label;
  final void Function(String, bool?)? _onChanged;
  final Map<String, bool> _items;
  OverlayEntry? _overlayEntry;
  ///
  _DropdownMultiselectButtonState({
    required Map<String, bool> items,
    String? label,
    double? height,
    double? width,
    double? itemHeight, 
    double? menuWidth,
    void Function(String, bool?)? onChanged,
  }) : 
    _items = items,
    _label = label,
    _width = width,
    _height = height,
    _itemHeight = itemHeight,
    _menuWidth = menuWidth,
    _onChanged = onChanged;
  //
  @override
  void dispose() {
    _removeOverlayEntry();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return SizedBox(
      height: _height,
      width: _width,
      child: ElevatedButton(
        onPressed: () => _toggleMenu(context), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _label ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(width: padding),
            Icon(
              _overlayEntry == null 
                ? Icons.arrow_drop_down
                : Icons.arrow_drop_up,
            ),
          ],
        ),
      ),
    );
  }
   ///
  void _toggleMenu(BuildContext context) {
    if (_overlayEntry != null) {
      _removeOverlayEntry();
    } else {
      final overlayState = Overlay.of(context);
      final RenderBox box = context.findRenderObject()! as RenderBox;
      final Offset position = box.localToGlobal(
        box.size.center(Offset.zero),
        ancestor: overlayState.context.findRenderObject(),
      );
      setState(() {
        _overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: position.dy,
            left: position.dx,
            child: MultiselectItemsListWidget(
              multiselectItems: _items,
              width: _menuWidth ?? 200, 
              itemHeight: _itemHeight ?? 20,
              onChanged: (key, value) {
                _onChanged?.call(key, value);
                // _toggleMenu(context);
                // _toggleMenu(context);
              },
            ),
          ),
        );
      });
      
      overlayState.insert(_overlayEntry!);
    }
  }
  ///
  void _removeOverlayEntry() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    Future.delayed(
      const Duration(milliseconds: 0), 
      () {
        if (mounted) {
          setState(() {
            _overlayEntry = null;
          });
        }
      },
    );
  }
}