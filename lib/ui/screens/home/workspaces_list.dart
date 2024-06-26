import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/navigation/indi_route.dart';
import 'package:indi_tool/providers/data/workspaces_prov.dart';
import 'package:indi_tool/providers/navigation/app_router_prov.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/schema/workspace.dart';
import 'package:indi_tool/ui/screens/home/workspaces_empty.dart';

class WorkspacesList extends ConsumerWidget {
  const WorkspacesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Workspace>> workspaces =
        ref.watch(workspacesProvider);

    final List<Widget> items = switch (workspaces) {
      AsyncData(value: final wspaces) when wspaces.isEmpty => List.empty(),
      AsyncData(value: final wspaces) => wspaces.map(
          (workspace) {
            return Column(
              children: [
                const Divider(height: 0),
                ListTile(
                  hoverColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.01),
                  leading: const Icon(Icons.dashboard_rounded),
                  title: Text(workspace.name),
                  onTap: () {
                    ref
                        .read(selectedWorkspaceProvider.notifier)
                        .select(workspace.id);
                    ref
                        .read(selectedRouteProvider.notifier)
                        .select(IndiRoute.workspace);
                  },
                ),
                const Divider(height: 0)
              ],
            );
          },
        ).toList(),
      _ => List.empty(),
    };

    return Expanded(
      child: Row(
        children: [
          const Expanded(flex: 2, child: Column()),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'All of your workspaces',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              enabled: false,
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Search',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(workspacesProvider.notifier)
                                    .addWorkspace(Workspace(
                                      name: 'New Workspace',
                                    ));
                                // TODO: Redirect to the new workspace.
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'New Workspace',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? const WorkspacesEmpty()
                      : ListView(
                          children: items,
                        ),
                ),
              ],
            ),
          ),
          const Expanded(flex: 2, child: Column()),
        ],
      ),
    );
  }
}
