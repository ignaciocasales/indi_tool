import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/dependencies.dart';
import 'package:indi_tool/schema/test_group.dart';

class TestGroupsTreeView extends ConsumerWidget {
  const TestGroupsTreeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TestGroup>> testGroups =
        ref.watch(testGroupsProvider);

    return Expanded(
      child: switch (testGroups) {
        AsyncData(value: final testGroup) => testGroup.isEmpty
            ? const Center(child: Text('Create a test group to get started'))
            : ListView(
                children: testGroup.map(
                  (testGroup) {
                    var parent = WorkItem(
                      id: testGroup.id,
                      type: WorkItemType.testGroup,
                    );

                    return TreeNodeWidget(
                      node: TreeNode(
                        title: testGroup.name,
                        isExpanded: true,
                        children: testGroup.testScenarios.asMap().entries.map(
                          (testScenarioEntry) {
                            final testScenario = testScenarioEntry.value;
                            return TreeNode(
                              title: testScenario.name,
                              isExpanded: false,
                              children: [],
                              onTap: (node) {
                                ref
                                    .read(selectedWorkItemProvider.notifier)
                                    .select(
                                      WorkItem(
                                        id: testScenarioEntry.key,
                                        type: WorkItemType.testCase,
                                        parent: parent,
                                      ),
                                    );
                              },
                            );
                          },
                        ).toList(),
                        onTap: (node) {
                          ref.read(selectedWorkItemProvider.notifier).select(
                                parent,
                              );
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
        AsyncError() => const Text('An error occurred'),
        _ => const CircularProgressIndicator(),
      },
    );
  }
}

class TreeNodeWidget extends StatelessWidget {
  final TreeNode node;
  final int level;

  const TreeNodeWidget({
    super.key,
    required this.node,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: level * 16.0),
      child: Column(
        children: [
          ListTile(
            title: Text(node.title),
            trailing: node.children.isNotEmpty
                ? Icon(node.isExpanded ? Icons.expand_less : Icons.expand_more)
                : null,
            onTap: () {
              /*onTap(node);*/
              node.onTap(node);
            },
          ),
          if (node.isExpanded)
            Column(
              children: node.children
                  .map((child) => TreeNodeWidget(
                        node: child,
                        level: level + 1,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class TreeNode {
  String title;
  List<TreeNode> children;
  bool isExpanded;
  final Function(TreeNode) onTap;

  TreeNode({
    required this.title,
    this.children = const [],
    this.isExpanded = false,
    required this.onTap,
  });
}
