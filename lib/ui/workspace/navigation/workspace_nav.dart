import 'package:flutter/material.dart';
import 'package:indi_tool/ui/workspace/navigation/workspace_nav_menu.dart';
import 'package:indi_tool/ui/workspace/navigation/workspace_nav_tree.dart';

class WorkspaceNav extends StatelessWidget {
  const WorkspaceNav({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 2,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WorkspaceNavMenu(),
              ],
            ),
          ),
          Divider(),
          WorkspaceNavTree(),
        ],
      ),
    );
  }
}
