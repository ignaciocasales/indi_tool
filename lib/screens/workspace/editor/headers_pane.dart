import 'package:flutter/material.dart';
import 'package:indi_tool/screens/workspace/editor/parameters/parameters_widget.dart';

class Headers extends StatelessWidget {
  const Headers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ParametersWidget(),
      ],
    );
  }
}
