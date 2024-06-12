import 'package:flutter/material.dart';
import 'package:indi_tool/ui/workspace/navigation/tree_view.dart';

class SideNavigationLayout extends StatelessWidget {
  const SideNavigationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 2,
      child: Column(
        children: [
          TreeViewExample(),
        ],
      ),
    );
  }
}
