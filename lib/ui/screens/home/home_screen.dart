import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/ui/screens/home/quick_start_guide.dart';
import 'package:indi_tool/ui/screens/home/welcome_message.dart';
import 'package:indi_tool/ui/screens/home/workspaces_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Expanded(
      child: Row(
        children: [
          Expanded(flex: 2, child: Column()),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                WelcomeMessage(),
                SizedBox(height: 20),
                QuickStartGuide(),
                SizedBox(height: 20),
                WorkspacesList(),
              ],
            ),
          ),
          Expanded(flex: 2, child: Column()),
        ],
      ),
    );
  }
}
