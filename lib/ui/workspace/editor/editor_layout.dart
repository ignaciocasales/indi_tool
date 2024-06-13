import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/dependencies.dart';
import 'package:indi_tool/services/http/http_method.dart';
import 'package:indi_tool/ui/workspace/editor/cases/case_layout.dart';
import 'package:indi_tool/ui/workspace/editor/groups/group_layout.dart';

class EditorLayout extends ConsumerWidget {
  const EditorLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workItem = ref.watch(selectedWorkItemProvider);

    var layout = switch (workItem) {
      WorkItem(type: final type) when type == WorkItemType.testGroup =>
        const GroupLayout(),
      WorkItem(type: final type) when type == WorkItemType.testCase =>
        const CaseLayout(),
      _ => const Center(child: Text('Select a request to view details')),
    };

    return Expanded(
      flex: 8,
      child: layout,
    );
  }
}

class HttpMethodDropdown extends ConsumerWidget {
  HttpMethodDropdown({super.key});

  final TextEditingController methodController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const selectedRequest = null;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<HttpMethod>(
          key: Key("method-${selectedRequest?.id}"),
          initialSelection: selectedRequest?.method ?? HttpMethod.get,
          controller: methodController,
          requestFocusOnTap: true,
          onSelected: (HttpMethod? newValue) {},
          dropdownMenuEntries: HttpMethod.values
              .map<DropdownMenuEntry<HttpMethod>>((HttpMethod type) {
            return DropdownMenuEntry<HttpMethod>(
              value: type,
              label: type.name,
            );
          }).toList(),
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          )),
    );
  }
}
