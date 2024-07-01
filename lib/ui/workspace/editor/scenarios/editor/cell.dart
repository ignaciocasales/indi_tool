import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CellEditingWidget extends ConsumerStatefulWidget {
  const CellEditingWidget({
    required this.controller,
    required this.hint,
    required this.text,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final String text;
  final void Function(String) onChanged;

  @override
  ConsumerState<CellEditingWidget> createState() => _CellEditingWidgetState();
}

class _CellEditingWidgetState extends ConsumerState<CellEditingWidget> {
  final _uniqueKey = UniqueKey();

  @override
  void initState() {
    // _controller = TextEditingController(text: widget.text);
    widget.controller.addListener(_onCellEdited);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onCellEdited);
    // _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CellEditingWidget old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      widget.controller.text = widget.text;
    }
  }

  void _onCellEdited() {
    widget.onChanged(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key('${widget.hint}-${_uniqueKey.toString()}'),
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        isDense: true,
        contentPadding: const EdgeInsets.all(8.0),
        border: InputBorder.none,
      ),
    );
  }
}
