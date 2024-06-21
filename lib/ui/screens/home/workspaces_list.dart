import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/navigation/indi_route.dart';
import 'package:indi_tool/providers/data/workspace_prov.dart';
import 'package:indi_tool/providers/data/workspaces_prov.dart';
import 'package:indi_tool/providers/navigation/app_router_prov.dart';
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
            return ListTile(
              title: Text(workspace.name),
              style: ListTileStyle.drawer,
              onTap: () async {
                await ref
                    .read(selectedWorkspaceProvider.notifier)
                    .select(workspace.id);
                ref
                    .read(selectedRouteProvider.notifier)
                    .select(IndiRoute.workspace);
              },
            );
          },
        ).toList(),
      _ => List.empty(),
    };

    return Expanded(
      child: Column(
        children: [
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'All of your workspaces',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  ref.read(workspacesProvider.notifier).addWorkspace();
                  // TODO: Redirect to the new workspace.
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text('New Workspace'),
                  ],
                )),
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
    );
  }
}
