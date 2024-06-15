import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/dependencies.dart';
import 'package:indi_tool/schema/test_group.dart';

class GroupLayout extends ConsumerWidget {
  const GroupLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WorkItem? workItem = ref.watch(selectedWorkItemProvider);

    return FutureBuilder<TestGroup>(
      future: ref.read(testGroupsProvider.notifier).get(workItem!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.name),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(testGroupsProvider.notifier)
                            .addTestScenario(snapshot.data!.id);
                      },
                      child: const Text('Add a Test Case'),
                    ),
                  ],
                ),
              )
            ],
          );
        }
      },
    );
  }
}
