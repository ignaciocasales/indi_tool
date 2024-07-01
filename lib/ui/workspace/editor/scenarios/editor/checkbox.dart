import 'package:flutter/material.dart';

class CheckBoxEditingWidget extends StatelessWidget {
  CheckBoxEditingWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final void Function(bool?)? onChanged;
  final _uniqueKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      key: Key('enabled-${_uniqueKey.toString()}'),
      value: value,
      onChanged: onChanged,
    );
  }
}
