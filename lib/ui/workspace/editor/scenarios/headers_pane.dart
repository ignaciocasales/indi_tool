import 'package:flutter/material.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/headers_widget.dart';

class Headers extends StatelessWidget {
  const Headers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HeadersWidget(),
      ],
    );
  }
}
