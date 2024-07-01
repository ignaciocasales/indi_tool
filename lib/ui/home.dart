import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/models/navigation/indi_route.dart';
import 'package:indi_tool/providers/navigation/app_router_prov.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/ui/navigation/app_router.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          kShortAppName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(selectedWorkspaceProvider.notifier).clear();
              ref.read(selectedTestGroupProvider.notifier).clear();
              ref.read(selectedTestScenarioProvider.notifier).clear();
              ref.read(selectedRouteProvider.notifier).select(IndiRoute.home);
            },
            child: Text(
              'HOME',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const Expanded(
            child: Row(
              children: [
                AppRouter(),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // TODO: Add real version number.
                Text('v0.0.1'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
