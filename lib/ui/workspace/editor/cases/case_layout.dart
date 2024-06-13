import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/dependencies.dart';
import 'package:indi_tool/ui/workspace/editor/cases/request_editor_nav.dart';
import 'package:indi_tool/ui/workspace/editor/cases/response_layout.dart';
import 'package:indi_tool/ui/workspace/editor/editor_layout.dart';

class CaseLayout extends ConsumerWidget {
  const CaseLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workItem = ref.watch(selectedWorkItemProvider);

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HttpMethodDropdown(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: Key("url-${workItem!.id}"),
                  /*initialValue: selectedRequest.url,*/
                  initialValue:
                  'https://jsonplaceholder.typicode.com/todos/1',
                  decoration: const InputDecoration(
                    hintText: "Enter URL",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () {
                  // Do something
                },
                child: const Row(
                  children: [
                    Text('Start'),
                    Icon(Icons.play_arrow),
                  ],
                ),
              ),
            )
          ],
        ),
        const Divider(
          height: 0,
        ),
        const Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequestEditorNav(),
              VerticalDivider(),
              ResponseLayout(),
            ],
          ),
        ),
      ],
    );
  }
}