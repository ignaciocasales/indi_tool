import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/ui/screens/home/quick_start_guide.dart';
import 'package:indi_tool/ui/screens/home/welcome_message.dart';
import 'package:indi_tool/ui/screens/home/workspaces_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Row(
        children: [
          const Expanded(flex: 2, child: Column()),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                const WelcomeMessage(),
                const SizedBox(height: 20),
                Divider(
                  height: 0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const QuickStartGuide(),
                const SizedBox(height: 20),
                Divider(
                  height: 0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const WorkspacesList(),
              ],
            ),
          ),
          const Expanded(flex: 2, child: Column()),
        ],
      ),
    );
  }
}
